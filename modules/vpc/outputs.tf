data "aws_availability_zones" "available" {
  state = "available"
}

output "list_of_az" {
  value = data.aws_availability_zones.available[*].names
}

output "nat_output" {
  value = aws_nat_gateway.nat
}


output "public_subnet_id" {
  value = values(aws_subnet.subnets_pub).*.id
}

output "vpc_id" {
  value = aws_vpc.main["main"].id
}

output "private_subnet_cidr" {
  value = values(aws_subnet.subnets_priv).*.cidr_block
}