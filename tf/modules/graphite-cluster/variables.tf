variable "public_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_file" {
  default = "~/.ssh/id_rsa"
}

locals {
  public_key  = "${file(var.public_key_file)}"
  private_key = "${file(var.private_key_file)}"
}

variable "username" {}

variable "aws_profile" {}

variable "aws_region" {}

variable "aws_availability_zone" {}

variable "aws_base_ami" {
  default = "ami-00035f41c82244dab" // Ubuntu 18.04 LTS
}

variable "aws_instance_type" {
  default = "t2.micro" // 1 vCPU, 1GB RAM
}

variable "ip_whitelist" {
  default = []
}
