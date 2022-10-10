resource "aws_vpc" "main" {
    dynamic "main_vpc" {
        for_each = var.main_vpc
        content{
            cidr_blocks = main_vpc.value.main
        }
    }
}