data "aws_availability_zones" "available" {
  state = "available"
}

output "list_of_az" {
  value = data.aws_availability_zones.available[*].names
}

output "nat_output" {
  value = aws_nat_gateway.nat
}