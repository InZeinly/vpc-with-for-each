output "list_of_az" {
  value = aws_subnet.main[*].availability_zone
}
