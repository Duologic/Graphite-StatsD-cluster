provider "local" {
  version = "~> 1.1"
}

data "template_file" "inventory-monitor-relay" {
  count    = "${var.monitor-relay_count}"
  template = "${file("templates/hostname.tpl")}"

  vars {
    name         = "${aws_instance.monitor-relay.*.tags.Name[count.index]}"
    ansible_host = "${aws_eip.monitor-relay-ip.*.public_ip[count.index]}"
    ansible_user = "${aws_instance.monitor-relay.*.tags.Username[count.index]}"
    extra        = ""
  }
}

data "template_file" "inventory-graphite-db" {
  count    = "${var.graphite-db_count}"
  template = "${file("templates/hostname.tpl")}"

  vars {
    name         = "${aws_instance.graphite-db.*.tags.Name[count.index]}"
    ansible_host = "${aws_instance.graphite-db.*.public_ip[count.index]}"
    ansible_user = "${aws_instance.graphite-db.*.tags.Username[count.index]}"
    extra        = ""
  }
}

data "template_file" "inventory-graphite-frontend" {
  count    = "${var.graphite-frontend_count}"
  template = "${file("templates/hostname.tpl")}"

  vars {
    name         = "${aws_instance.graphite-frontend.*.tags.Name[count.index]}"
    ansible_host = "${aws_eip.graphite-frontend-ip.*.public_ip[count.index]}"
    ansible_user = "${aws_instance.graphite-frontend.*.tags.Username[count.index]}"
    extra        = ""
  }
}

data "template_file" "ansible_inventory" {
  template = "${file("templates/ansible_inventory.tpl")}"

  vars {
    env                     = "${var.aws_profile}"
    monitor-relay_hosts     = "${join("",data.template_file.inventory-monitor-relay.*.rendered)}"
    graphite-db_hosts       = "${join("",data.template_file.inventory-graphite-db.*.rendered)}"
    graphite-frontend_hosts = "${join("",data.template_file.inventory-graphite-frontend.*.rendered)}"
    carbon_caches           = "[${join(",",formatlist("'%s'", aws_instance.graphite-db.*.private_ip))}]"
    cluster_servers         = "[${join(",",formatlist("'%s'", aws_instance.graphite-db.*.private_ip))}]"
    carbon_relay            = "127.0.0.1"
    carbon_server           = "${aws_instance.monitor-relay.*.private_ip[0]}"
  }
}

resource "local_file" "terraform_inventory" {
  content  = "${data.template_file.ansible_inventory.rendered}"
  filename = "terraform_inventory"
}

output "ansible_inventory" {
  value = "${data.template_file.ansible_inventory.rendered}"
}
