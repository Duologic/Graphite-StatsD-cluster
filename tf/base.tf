provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
  version = "~> 1.55"
}

resource "aws_key_pair" "local" {
  key_name   = "${var.username}"
  public_key = "${local.public_key}"
}
