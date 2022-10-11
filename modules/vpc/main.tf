resource "aws_vpc" "main" {
    for_each = var.vpc
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
}


# ask about using other resource variable from for each to another one
resource "aws_subnet" "privates" {
    vpc_id = aws_vpc.main["main"].id
    for_each = var.subnets
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
    #availability_zone = tostring(data.aws_availability_zones.available.names)

    depends_on = [
      aws_vpc.main
    ]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  for_each = aws_vpc.main
  vpc_id = aws_vpc.main["main"].id
}
