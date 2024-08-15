resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "app"
  }
}
 
resource "aws_subnet" "app_subnet" {
  for_each = var.subnet_configs

  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.zone
  map_public_ip_on_launch = each.value.subnet_type == "public"

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  for_each = { for k, v in aws_subnet.app_subnet : k => v if v.tags.Name == "public1" || v.tags.Name == "public2" }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  for_each = { for k, v in aws_subnet.app_subnet : k => v if v.tags.Name == "app1" || v.tags.Name == "app2" || v.tags.Name == "db1" || v.tags.Name == "db2" }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_internet_gateway" "app_vpc_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "app-igw"
  }
}



resource "aws_nat_gateway" "app_vpc_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.app_subnet["public1"].id 

  tags = {
    Name = "app-vpc-nat-gateway"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# Route for Internet Gateway
resource "aws_route" "app_public_internet_gateway" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_vpc_igw.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_vpc_nat_gateway.id
}

resource "aws_instance" "instance" {
  for_each = { for k, v in var.subnet_configs : k => v if v.subnet_type == "private" }

  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.deployer.key_name
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet[each.key].id
  vpc_security_group_ids = [aws_security_group.private_instance_sg[each.key].id]

  tags = {
    Name = "${each.key}-instance"
  }
}

resource "aws_security_group" "private_instance_sg" {
  for_each = { for k, v in var.subnet_configs : k => v if v.subnet_type == "private" }

  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [ aws_security_group.bastion_access.id ]
  }

  tags = {
    Name = "${each.key}-security-group"
  }
}

