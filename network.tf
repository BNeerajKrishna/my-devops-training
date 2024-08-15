# # VPC
# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "demo-vpc"
#   }
# }

# resource "aws_subnet" "public_1" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "ap-south-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-1"
#   }
# }

# resource "aws_subnet" "public_2" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "ap-south-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-2"
#   }
# }

# resource "aws_subnet" "app_1" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "ap-south-1a"
#   tags = {
#     Name = "app-subnet-1"
#   }
# }

# resource "aws_subnet" "app_2" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.4.0/24"
#   availability_zone = "ap-south-1b"
#   tags = {
#     Name = "app-subnet-2"
#   }
# }

# resource "aws_subnet" "db_1" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.5.0/24"
#   availability_zone = "ap-south-1a"
#   tags = {
#     Name = "db-subnet-1"
#   }
# }

# resource "aws_subnet" "db_2" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.6.0/24"
#   availability_zone = "ap-south-1b"
#   tags = {
#     Name = "db-subnet-2"
#   }
# }

# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "my-internet-gateway"
#   }
# }

# resource "aws_eip" "nat" {
#   tags = {
#     Name = "my-nat-eip"
#   }
# }

# resource "aws_nat_gateway" "main" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_1.id
#   tags = {
#     Name = "my-nat-gateway"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }
#   tags = {
#     Name = "public-route-table"
#   }
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main.id
#   }
#   tags = {
#     Name = "private-route-table"
#   }
# }

# locals {
#   public_subnets = {
#     "public_1" = aws_subnet.public_1.id
#     "public_2" = aws_subnet.public_2.id
#   }
# }

# resource "aws_route_table_association" "public_subnet" {
#   for_each = local.public_subnets

#   subnet_id      = each.value
#   route_table_id = aws_route_table.public.id
# }

# locals {
#   private_subnets = {
#     "app_1" = aws_subnet.app_1.id
#     "app_2" = aws_subnet.app_2.id
#     "db_1"  = aws_subnet.db_1.id
#     "db_2"  = aws_subnet.db_2.id
#   }
# }

# resource "aws_route_table_association" "private_subnet" {
#   for_each = local.private_subnets

#   subnet_id      = each.value
#   route_table_id = aws_route_table.private.id
# }
