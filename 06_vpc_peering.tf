resource "aws_vpc_peering_connection" "app_mgmt_peering" {
  vpc_id            = aws_vpc.app_vpc.id
  peer_vpc_id       = aws_vpc.mgmt_vpc.id
  auto_accept       = true

  tags = {
    Name = "app-mgmt-vpc-peering"
  }
}

resource "aws_route" "app_vpc_mgmt_peering_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = aws_vpc.mgmt_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.app_mgmt_peering.id
}

resource "aws_route" "mgmt_vpc_app_peering_route" {
  route_table_id            = aws_route_table.mgmt_route_table.id
  destination_cidr_block    = aws_vpc.app_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.app_mgmt_peering.id
}