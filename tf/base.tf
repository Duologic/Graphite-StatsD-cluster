provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
  version = "~> 1.55"
}

resource "aws_key_pair" "local" {
  key_name   = "${var.username}"
  public_key = "${local.public_key}"
}

resource "aws_instance" "monitor-relay" {
  ami           = "ami-3548444c"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.local.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.allow_web.id}",
    "${aws_security_group.allow_ssh.id}",
  ]

  root_block_device = {
    delete_on_termination = true
  }

  tags = {
    Name     = "monitor-relay"
    Username = "centos"
  }

  provisioner "local-exec" {
    command = "echo export AWS_PROFILE=${var.aws_profile} > files/bash-prompt.sh && cat files/bash-prompt-default.sh >> files/bash-prompt.sh"
  }

  provisioner "file" {
    source      = "files/bash-prompt.sh"
    destination = "/tmp/bash-prompt.sh"

    connection {
      type  = "ssh"
      user  = "centos"
      agent = true
    }
  }

  provisioner "local-exec" {
    command = "rm files/bash-prompt.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/bash-prompt.sh /etc/profile.d/bash-prompt.sh",
      "sudo yum install -y epel-release",
      "sudo yum install -y htop vim telnet curl",
      "sudo hostnamectl set-hostname ${self.tags.Name}",
    ]

    connection {
      type = "ssh"
      user = "centos"
    }
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.monitor-relay.id}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from home/offices"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["84.193.109.126/32", "84.199.16.2/32"]
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow reguler internet access"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
