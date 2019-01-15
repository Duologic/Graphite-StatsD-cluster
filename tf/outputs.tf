output "ssh_command" {
  value = "ssh ${aws_instance.monitor-relay.tags.Username}@${aws_eip.ip.public_ip}"
}
