resource "aws_iam_user_ssh_key" "user" {
  username   = "${var.username}"
  encoding   = "SSH"
  public_key = "${local.public_key}"
}
