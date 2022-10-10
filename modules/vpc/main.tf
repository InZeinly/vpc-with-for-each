resource "aws_vpc" "main" {
    for_each = var.vpc
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
}


resource "aws_subnet" "privates" {
    for_each = var.subprivate
    vpc_id = var.vpc.id
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
}