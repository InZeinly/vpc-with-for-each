resource "aws_vpc" "main" {
  for_each = var.main-vpc
  cidr_block = each.value.default
}