module "graphite-cluster" {
  source                = "./modules/graphite-cluster"
  username              = "${var.username}"
  aws_profile           = "${var.aws_profile}"
  aws_region            = "${var.aws_region}"
  aws_availability_zone = "${var.aws_availability_zone}"
  ip_whitelist          = "${var.ip_whitelist}"
}
