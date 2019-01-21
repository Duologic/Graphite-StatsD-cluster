resource "aws_eip" "graphite-frontend-ip" {
  count    = "${var.graphite-frontend_count}"
  instance = "${aws_instance.graphite-frontend.*.id[count.index]}"
}

resource "aws_instance" "graphite-frontend" {
  count             = "${var.graphite-frontend_count}"
  ami               = "${var.aws_base_ami}"
  instance_type     = "${var.aws_instance_type}"
  availability_zone = "${var.aws_availability_zone}"
  key_name          = "${aws_key_pair.local.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.allow_web.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_graphite_web.id}",
  ]

  root_block_device = {
    delete_on_termination = true
  }

  tags = {
    Name     = "graphite-frontend${count.index}"
    Role     = "graphite-frontend"
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

      //"echo source\ /etc/profile.d/bash-prompt.sh >> ~/.bashrc",
      //"sudo su -c 'echo source\ /etc/profile.d/bash-prompt.sh >> ~/.bashrc'",
      "sudo apt-get install -y htop vim telnet curl python",

      "sudo hostnamectl set-hostname ${self.tags.Name}",
    ]
  }
}
