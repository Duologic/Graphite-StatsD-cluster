resource "aws_eip" "monitor-relay-ip" {
  count    = "${var.monitor_relay_count}"
  instance = "${aws_instance.monitor-relay.*.id[count.index]}"
}

resource "aws_instance" "monitor-relay" {
  count         = "${var.monitor_relay_count}"
  ami           = "ami-3548444c"                   // CentOS 7 AMI
  instance_type = "t2.micro"                       // 1 vCPU, 1GB RAM
  key_name      = "${aws_key_pair.local.key_name}"

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
    Username = "centos"
  }

  connection {
    type  = "ssh"
    user  = "${self.tags.Username}"
    agent = true
  }

  provisioner "local-exec" {
    command = "echo export AWS_PROFILE=${var.aws_profile} > files/bash-prompt.sh.tmp && cat files/bash-prompt-default.sh >> files/bash-prompt.sh.tmp"
  }

  provisioner "file" {
    source      = "files/bash-prompt.sh.tmp"
    destination = "/tmp/bash-prompt.sh"
  }

  provisioner "local-exec" {
    command = "rm files/bash-prompt.sh.tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/bash-prompt.sh /etc/profile.d/bash-prompt.sh",
      "sudo yum install -y epel-release",
      "sudo yum install -y htop vim telnet curl",
      "sudo hostnamectl set-hostname ${self.tags.Name}",
    ]
  }
}
