data "aws_availability_zones" "available" {
  state = "available"
}

output "list_of_az" {
  value = data.aws_availability_zones.available[*].names
}

output "rts" {
  value = aws_route_table.RT.*.route_table_id
}

output "subnet" {
  value = aws_subnet.subnets.*.id
}