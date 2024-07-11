
locals {
  web_vm_name  = "${var.name}-${var.env}-web"
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

resource "aws_key_pair" "deployer" {
  key_name   = "testkey"
  public_key = file("${path.module}/mykey.pub")
}

resource "aws_security_group" "ssh__access" {
  name        = "ssh_access_sg"
  description = "Security group allowing SSH access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ssh_apache_access" {
  name        = "ssh_apache_access_sg"
  description = "Security group allowing SSH access to Apache host"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ssh_nginx_access" {
  name        = "ssh_nginx_access_sg"
  description = "Security group allowing SSH access to Apache host"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# resource "aws_instance" "test" {
#   count                       = var.instance_count
#   ami                         = data.aws_ami.ubuntu.id
#   key_name                    = aws_key_pair.deployer.key_name
#   security_groups             = [aws_security_group.ssh_access.id]
#   associate_public_ip_address = var.public_ip_enable
#   instance_type               = tolist(var.vm_types)[count.index]
#   subnet_id                   = "subnet-0d6f05c5f211798cb"
#   availability_zone           = "ap-south-1a"

#   user_data = <<-EOF
# #!/bin/bash -xe
# sudo chown -R ubuntu:ubuntu /home/ubuntu
# sudo date | tee -a /home/ubuntu/go-user.log
# echo "updating packages" | tee -a /home/ubuntu/go-user.log
# apt-get update
# echo "installing git" | tee -a /home/ubuntu/go-user.log
# apt-get install -y git golang-go
# echo "creating directory" | tee -a /home/ubuntu/go-user.log
# mkdir /home/ubuntu/user
# echo "entering directory" | tee -a /home/ubuntu/go-user.log
# cd /home/ubuntu/user
# echo "printing content in test file" | tee -a /home/ubuntu/go-user.log
# echo "hello" | tee -a test.txt
# echo "cloning my-go-app repository " | tee -a /home/ubuntu/go-user.log
# git clone https://github.com/BNeerajKrishna/my-go-app.git
# echo "entering my-go-app repo" | tee -a /home/ubuntu/go-user.log
# cd /home/ubuntu/user/my-go-app
# echo "executing main.go file" | tee -a /home/ubuntu/go-user.log
# nohup go run main.go &> /home/ubuntu/app.log
# echo "completion of execution" | tee -a /home/ubuntu/go-user.log
# EOF

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("./mykey")
#     host        = aws_instance.test[count.index].public_ip
#   }

#   provisioner "file" {
#     source      = "scripts/nginx.sh"
#     destination = "/tmp/script.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo chmod +x /tmp/script.sh",
#       "sudo /tmp/script.sh",
#     ]
#   }

#   tags = {
#     Name = "${var.name}-${count.index + 1}"
#   }
# }

resource "aws_instance" "ansible_controller" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.deployer.key_name
  security_groups             = [aws_security_group.ssh__access.id]
  associate_public_ip_address = var.public_ip_enable
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0d6f05c5f211798cb"
  availability_zone           = "ap-south-1a"

  tags = {
    Name = "ansible-controller"
  }
}

resource "null_resource" "ansible_controller" {
  depends_on = [ aws_instance.ansible_controller, aws_instance.nginx_host, aws_instance.apache_host ]
  triggers = { 
    value = aws_instance.ansible_controller.id
    # always_run = "${timestamp()}"
     }

  connection {
    user = "ubuntu"
    private_key = file("./mykey")
    host = aws_instance.ansible_controller.public_ip
  }

  provisioner "file" {
    source = "./ansible"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source = "mykey"
    destination = "/home/ubuntu/ansible/mykey"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sleep 20",
      "sudo apt update",
      "sleep 10",
      "sudo apt install ansible -y",
      "ls -al /home/ubuntu",
      "ls -al /home/ubuntu/ansible",
      "cd /home/ubuntu/ansible",
      "sed -i -e 's/NGINX_HOST_IP/${aws_instance.nginx_host.public_ip}/g' hosts",
      "sed -i -e 's/APACHE_HOST_IP/${aws_instance.apache_host.public_ip}/g' hosts",
      "chmod 400 mykey",
      "ansible-playbook -i hosts playbook.yml"
    ]  
  }
}

resource "aws_instance" "nginx_host" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.deployer.key_name
  security_groups             = [aws_security_group.ssh_nginx_access.id]
  associate_public_ip_address = var.public_ip_enable
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0d6f05c5f211798cb"
  availability_zone           = "ap-south-1a"

  tags = {
    Name = "nginx_host"
  }
}

resource "aws_instance" "apache_host" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.deployer.key_name
  security_groups             = [aws_security_group.ssh_apache_access.id]
  associate_public_ip_address = var.public_ip_enable
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0d6f05c5f211798cb"
  availability_zone           = "ap-south-1a"

  tags = {
    Name = "apache_host"
  }
}



resource "aws_s3_bucket" "my_bucket" {
  count  = var.env == "production" ? 1 : 0
  bucket = var.bucket_name
}

resource "aws_instance" "web" {
  for_each                    = var.env == "production" ? toset(var.zone_names) : toset([])
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = tolist(var.vm_types)[0]
  associate_public_ip_address = var.public_ip_enable
  availability_zone           = each.value

  tags = {
    Name = "${local.web_vm_name}"
  }
}

resource "aws_instance" "data" {
  for_each                    = var.env == "production" ? toset(var.vm_types) : toset([])
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value
  associate_public_ip_address = var.public_ip_enable
  availability_zone           = "ap-south-1a"

  tags = {
    Name = "${local.data_vm_name}"
  }
}