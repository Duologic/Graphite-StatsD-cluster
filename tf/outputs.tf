output "ssh_command" {
  value = "ssh ${aws_instance.monitor-relay.tags.Username}@${aws_eip.monitor-relay-ip.public_ip}"
}
