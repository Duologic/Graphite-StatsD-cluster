provider "aws" {
  region  = "${var.region}"
  profile = "unleashed-staging"
  version = "~> 1.55"
}

resource "aws_key_pair" "local" {
  key_name   = "${aws_iam_user_ssh_key.user.username}"
  public_key = "${aws_iam_user_ssh_key.user.public_key}"
}

resource "aws_instance" "monitor-relay" {
  ami           = "ami-3548444c"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.local.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.allow_ssh.id}",
  ]

  tags = {
    Name = "monitor-relay"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.monitor-relay.id}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from Jeroen Op t Eyndes home"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["84.193.109.126/32"]
  }
}
