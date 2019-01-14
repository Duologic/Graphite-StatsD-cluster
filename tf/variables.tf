variable "region" {
  default = "eu-west-1"
}

variable "username" {
  default = "jeroen.opteynde"
}

locals {
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
