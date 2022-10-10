resource "aws_vpc" "main" {
    for_each = var.vpc
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
}


resource "aws_subnet" "privates" {
    vpc_id = var.vpc.id
    for_each = var.subprivate
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
  
}