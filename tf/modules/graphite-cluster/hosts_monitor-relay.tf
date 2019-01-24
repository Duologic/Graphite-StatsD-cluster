resource "aws_instance" "monitor-relay" {
  count             = "${var.monitor-relay_count}"
  ami               = "${var.aws_base_ami}"
  instance_type     = "${var.aws_instance_type}"
  availability_zone = "${var.aws_availability_zone}"
  key_name          = "${aws_key_pair.local.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.allow_web.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_statsd.id}",
    "${aws_security_group.allow_carbon.id}",
  ]

  root_block_device = {
    delete_on_termination = true
  }

  tags = {
    Name     = "monitor-relay${count.index}"
    Role     = "monitor-relay"
    Username = "ubuntu"
  }

  connection {
    type  = "ssh"
    user  = "${self.tags.Username}"
    agent = true
  }

  provisioner "file" {
    content     = "${data.template_file.bash_prompt.rendered}"
    destination = "/tmp/bash-prompt.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/bash-prompt.sh /etc/profile.d/bash-prompt.sh",
      "sudo chown +x /etc/profile.d/bash-prompt.sh",
      "echo 'source /etc/profile.d/bash-prompt.sh' >> ~/.bashrc",

      //"sudo su -c 'echo source\ /etc/profile.d/bash-prompt.sh >> ~/.bashrc'",
      "sudo apt-get install -y htop vim telnet curl python",

      "sudo hostnamectl set-hostname ${self.tags.Name}",
    ]
  }
}

resource "aws_eip" "monitor-relay-ip" {
  count    = "${var.monitor-relay_count}"
  instance = "${aws_instance.monitor-relay.*.id[count.index]}"
}
