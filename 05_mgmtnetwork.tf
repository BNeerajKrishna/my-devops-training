resource "aws_vpc" "mgmt_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "mgmt"
  }
}

resource "aws_subnet" "mgmt_subnet" {
  vpc_id                  = aws_vpc.mgmt_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "mgmt-subnet"
  }
}

resource "aws_internet_gateway" "mgmt_igw" {
  vpc_id = aws_vpc.mgmt_vpc.id
  tags = {
    Name = "mgmt-igw"
  }
}

resource "aws_route_table" "mgmt_route_table" {
  vpc_id = aws_vpc.mgmt_vpc.id
  tags = {
    Name = "mgmt-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.mgmt_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mgmt_igw.id
}

resource "aws_route_table_association" "mgmt_subnet_association" {
  subnet_id      = aws_subnet.mgmt_subnet.id
  route_table_id = aws_route_table.mgmt_route_table.id
}


resource "aws_instance" "bastion_instance" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.deployer.key_name
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.mgmt_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_access.id]
  availability_zone      = "ap-south-1a"

  tags = {
    Name = "bastion-instance"
  }
}

resource "aws_security_group" "bastion_access" {
  name   = "bastion_access_sg"
  vpc_id = aws_vpc.mgmt_vpc.id

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

  tags = {
    Name = "bastion-security-group"
  }
}