resource "aws_eip" "graphite-db-ip" {
  count    = "${var.graphite-db_count}"
  instance = "${aws_instance.graphite-db.*.id[count.index]}"
}

resource "aws_instance" "graphite-db" {
  count             = "${var.graphite-db_count}"
  ami               = "${var.aws_base_ami}"
  instance_type     = "${var.aws_instance_type}"
  availability_zone = "${var.aws_availability_zone}"
  key_name          = "${aws_key_pair.local.key_name}"
  user_data         = "${data.template_file.whisper-disk-user_data.*.rendered[count.index]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow_web.id}",
    "${aws_security_group.allow_ssh.id}",
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

      //"echo source\ /etc/profile.d/bash-prompt.sh >> ~/.bashrc",
      //"sudo su -c 'echo source\ /etc/profile.d/bash-prompt.sh >> ~/.bashrc'",
      "sudo apt-get install -y htop vim telnet curl python",

      "sudo hostnamectl set-hostname ${self.tags.Name}",
    ]
  }
}

resource "aws_ebs_volume" "whisper-disk" {
  count             = "${var.graphite-db_count}"
  availability_zone = "${var.aws_availability_zone}"
  size              = 100
  type              = "io1"
  iops              = 100

  tags = {
    Name       = "whisper-disk${count.index}"
    DeviceName = "/dev/sdh"
    Device     = "/dev/xvdh"
  }
}

resource "aws_volume_attachment" "whisper-disk-attach" {
  count       = "${var.graphite-db_count}"
  device_name = "${aws_ebs_volume.whisper-disk.*.tags.DeviceName[count.index]}"
  volume_id   = "${aws_ebs_volume.whisper-disk.*.id[count.index]}"
  instance_id = "${aws_instance.graphite-db.*.id[count.index]}"
}

data "template_file" "whisper-disk-user_data" {
  count    = "${var.graphite-db_count}"
  template = "${file("templates/mount_whisper.sh.tpl")}"

  vars {
    DEVICE      = "${aws_ebs_volume.whisper-disk.*.tags.Device[count.index]}"
    MOUNT_POINT = "/whisper"
  }
}
