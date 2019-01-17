variable "ip_whitelist" {
  default = ["84.193.109.126/32", "84.199.16.2/32"]
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow reguler internet access"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from home/offices"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.ip_whitelist}"
  }
}

resource "aws_security_group" "allow_statsd" {
  name        = "allow_statsd"
  description = "Allow StatsD inputs from home/offices"

  ingress {
    from_port   = 8125
    to_port     = 8125
    protocol    = "udp"
    cidr_blocks = "${var.ip_whitelist}"
  }

  ingress {
    from_port   = 8126                  // Statsdaemon telnet mgmt interface
    to_port     = 8126
    protocol    = "tcp"
    cidr_blocks = "${var.ip_whitelist}"
  }
}

resource "aws_security_group" "allow_carbon" {
  name        = "allow_carbon"
  description = "Allow Graphite Carbon inputs from home/offices"

  ingress {
    from_port   = 2003
    to_port     = 2004
    protocol    = "tcp"
    cidr_blocks = "${var.ip_whitelist}"
  }

  ingress {
    from_port   = 8081                  // Carbon-relay-ng web mgmt interface
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = "${var.ip_whitelist}"
  }
}
