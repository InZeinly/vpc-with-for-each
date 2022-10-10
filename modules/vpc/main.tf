resource "aws_vpc" "main" {
    dynamic "cidr_block" {
        for_each = var.main_vpc
        content{
            cidr_blocks = main_vpc.value.main
        }
    }
}