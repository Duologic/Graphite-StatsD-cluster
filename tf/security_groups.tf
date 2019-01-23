resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow reguler internet access"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
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
    cidr_blocks = ["${formatlist("%s/32", aws_instance.graphite-frontend.*.private_ip)}"]
  }

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

resource "aws_security_group" "allow_carbon_forwards" {
  name        = "allow_carbon_forwards"
  description = "Allow Graphite Carbon forwards from the relay"

  ingress {
    from_port   = 2003
    to_port     = 2004
    protocol    = "tcp"
    cidr_blocks = ["${formatlist("%s/32", aws_instance.monitor-relay.*.private_ip)}"]
  }

  ingress {
    from_port   = 3032
    to_port     = 3032
    protocol    = "tcp"
    cidr_blocks = ["${formatlist("%s/32", aws_instance.graphite-frontend.*.private_ip)}"]
  }
}

resource "aws_security_group" "allow_graphite_web" {
  name        = "allow_graphite_web"
  description = "Allow Graphite web access from home/office"

  ingress {
    from_port   = 3032                  // Graphite-web interface (also API)
    to_port     = 3032
    protocol    = "tcp"
    cidr_blocks = "${var.ip_whitelist}"
  }

  ingress {
    from_port   = 3000                  // Grafana web interface
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = "${var.ip_whitelist}"
  }
}
