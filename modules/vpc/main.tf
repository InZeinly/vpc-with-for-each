resource "aws_vpc" "main" {
    dynamic "cidr" {
        for_each = var.main-vpc
        content{
            cidr_blocks = cidr.value.cidr_blocks
        }
    }
}