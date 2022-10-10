resource "aws_vpc" "main" {
    for_each = var.main_vpc
    cidr_block = each.value
}