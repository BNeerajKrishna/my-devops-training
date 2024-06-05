
locals {
  web_vm_name = "${var.name}-${var.env}-web"

  data_vm_name = "${var.name}-${var.env}-db"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "web" {
  for_each                    = toset(var.zone_names)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = tolist(var.vm_types)[0]
  associate_public_ip_address = var.public_ip_enable
  availability_zone           = each.value

  tags = {
    Name = "${local.web_vm_name}"
  }
}
resource "aws_instance" "data" {
  for_each                    = toset(var.vm_types)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value
  associate_public_ip_address = var.public_ip_enable
  availability_zone           = "ap-south-1a"

  tags = {
    Name = "${local.data_vm_name}"
  }
}
resource "aws_instance" "test" {
  count             = var.instance_count
  ami               = data.aws_ami.ubuntu.id
  instance_type     = tolist(var.vm_types)[count.index]
  availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.name}-${count.index + 1}"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  count = var.env == "production" ? 1 : 0
  bucket = var.bucket_name
}