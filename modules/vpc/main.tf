resource "aws_vpc" "main" {
    for_each = var.vpc
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
}


# ask about using other resource variable from for each to another one
resource "aws_subnet" "privates" {
    vpc_id = aws_vpc.main["cidr"]
    for_each = var.subprivate
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]

    depends_on = [
      aws_vpc.main
    ]
}