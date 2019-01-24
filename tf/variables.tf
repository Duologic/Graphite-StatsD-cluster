locals {
  public_key  = "${file("~/.ssh/id_rsa.pub")}"
  private_key = "${file("~/.ssh/id_rsa")}"
}

variable "username" {
  default = "jeroen.opteynde"
}

variable "aws_profile" {
  default = "unleashed-staging"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_availability_zone" {
  default = "eu-west-1b"
}

variable "aws_base_ami" {
  default = "ami-00035f41c82244dab" // Ubuntu 18.04 LTS
}

variable "aws_instance_type" {
  default = "t2.micro" // 1 vCPU, 1GB RAM
}

variable "ip_whitelist" {
  default = ["84.193.109.126/32", "84.199.16.2/32"]
}
