provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
  version = "~> 1.55"
}

provider "template" {
  version = "~> 2.0"
}

resource "aws_key_pair" "local" {
  key_name   = "${var.username}"
  public_key = "${local.public_key}"
}

data "template_file" "bash_prompt" {
  template = "${file("templates/bash-prompt.sh.tpl")}"

  vars {
    aws_profile = "${var.aws_profile}"
  }
}
