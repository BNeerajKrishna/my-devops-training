
locals {
  fullname = "${var.name}-${var.env}"
}
locals {
  fullname2 = "${var.name}-${var.name2}"
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
  instance_type               = var.vm_type
  associate_public_ip_address = var.public_ip_enable
  availability_zone           = each.value

  tags = {
    Name = "${local.fullname}-${each.value}"
  }
}
resource "aws_instance" "data" {
  for_each                    = toset(var.vm_type2)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value
  associate_public_ip_address = var.public_ip_enable
  availability_zone           = "ap-south-1a"

 tags = {
    Name = "${local.fullname2}-${each.value}"
  }
}
resource "aws_instance" "test" {
  count = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"

tags = {
   Name = "${var.name}${var.name3[count.index]}"
  }
}

  


resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}