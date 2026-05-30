# Transit Gateway
resource "aws_ec2_transit_gateway" "onprem_transit_gateway" {
  description = "Connects the main VPC to the OnPrem VPC"
}

# Connecting the vpc to the gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "tg_vpc_onprem_attach" {
  subnet_ids         = [aws_subnet.onprem_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.onprem_transit_gateway.id
  vpc_id             = aws_vpc.vpc_onprem.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tg_vpc_tei_attach" {
  subnet_ids         = [aws_subnet.public_subnet_1.id]
  transit_gateway_id = aws_ec2_transit_gateway.onprem_transit_gateway.id
  vpc_id             = aws_vpc.vpc_tei.id
}

# Route Table
resource "aws_ec2_transit_gateway_route_table" "onprem_tg_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.onprem_transit_gateway.id
}

# Route Table Propogation - 
resource "aws_ec2_transit_gateway_route_table_propagation" "onprem_route_table_propogate" {
  transit_gateway_attachment_id  = [aws_ec2_transit_gateway_vpc_attachment.tg_vpc_tei_attach.id]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.onprem_tg_route_table.id
}

# Route
resource "aws_ec2_transit_gateway_route" "tei_tg_route" {
  destination_cidr_block         = "10.0.0.0/16"
  transit_gateway_attachment_id  = [aws_ec2_transit_gateway_vpc_attachment.tg_vpc_tei_attach.id]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.onprem_tg_route_table.id
}