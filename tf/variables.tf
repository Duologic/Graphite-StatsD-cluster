variable "username" {
  default = "jeroen.opteynde"
}

variable "aws_profile" {
  default = "unleashed-staging"
}

variable "aws_region" {
  default = "eu-west-1"
}

locals {
  public_key  = "${file("~/.ssh/id_rsa.pub")}"
  private_key = "${file("~/.ssh/id_rsa")}"
}

variable "monitor_relay_count" {
  default = 2
}
