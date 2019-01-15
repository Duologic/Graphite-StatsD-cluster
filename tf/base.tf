provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
  version = "~> 1.55"
}

resource "aws_key_pair" "local" {
  key_name   = "${var.username}"
  public_key = "${local.public_key}"
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
