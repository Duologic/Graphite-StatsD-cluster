resource "aws_instance" "graphite-db" {
  count             = "${var.graphite-db_count}"
  ami               = "${var.aws_base_ami}"
  instance_type     = "${var.aws_instance_type}"
  availability_zone = "${var.aws_availability_zone}"
  key_name          = "${aws_key_pair.local.key_name}"
  user_data         = "${data.template_file.graphite-disk-user_data.*.rendered[count.index]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow_web.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_carbon_forwards.id}",
  ]

  root_block_device = {
    delete_on_termination = true
  }

  tags = {
    Name     = "graphite-db${count.index}"
    Role     = "graphite-db"
    Username = "ubuntu"
  }

  connection {
    type  = "ssh"
    user  = "${self.tags.Username}"
    agent = true
  }

  provisioner "file" {
    content     = "${data.template_file.bash_prompt.rendered}"
    destination = "/tmp/bash-prompt.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/bash-prompt.sh /etc/profile.d/bash-prompt.sh",
      "sudo chown +x /etc/profile.d/bash-prompt.sh",
      "echo 'source /etc/profile.d/bash-prompt.sh' >> ~/.bashrc",

      //"sudo su -c 'echo source\ /etc/profile.d/bash-prompt.sh >> ~/.bashrc'",
      "sudo apt-get install -y htop vim telnet curl python",

      "sudo hostnamectl set-hostname ${self.tags.Name}",
    ]
  }
}

resource "aws_ebs_volume" "graphite-disk" {
  count             = "${var.graphite-db_count}"
  availability_zone = "${var.aws_availability_zone}"
  size              = 100
  type              = "io1"
  iops              = 100

  tags = {
    Name       = "graphite-disk${count.index}"
    DeviceName = "/dev/sdh"
    Device     = "/dev/xvdh"
  }

  lifecycle = {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "graphite-disk-attach" {
  count       = "${var.graphite-db_count}"
  device_name = "${aws_ebs_volume.graphite-disk.*.tags.DeviceName[count.index]}"
  volume_id   = "${aws_ebs_volume.graphite-disk.*.id[count.index]}"
  instance_id = "${aws_instance.graphite-db.*.id[count.index]}"
}

data "template_file" "graphite-disk-user_data" {
  count    = "${var.graphite-db_count}"
  template = "${file("${path.module}/templates/mount_aws_volume.sh.tpl")}"

  vars {
    DEVICE      = "${aws_ebs_volume.graphite-disk.*.tags.Device[count.index]}"
    MOUNT_POINT = "/opt/graphite"
  }
}
