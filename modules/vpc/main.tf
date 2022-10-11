resource "aws_vpc" "main" {
    for_each = var.vpc
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
}


# ask about using other resource variable from for each to another one
# Creting Privates and Public
resource "aws_subnet" "subnets" {
    vpc_id = aws_vpc.main["main"].id
    for_each = var.subnets
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
    #availability_zone = tostring(data.aws_availability_zones.available.names)

    depends_on = [
      aws_vpc.main
    ]
}

# Gateways and Elastic ip
resource "aws_internet_gateway" "igw" {
  for_each = aws_vpc.main
  vpc_id = aws_vpc.main["main"].id
}

resource "aws_eip" "elastic" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic.id
  subnet_id = aws_subnet.subnets["Public1"].id

  tags = {
    "Name" = "nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

# Route tables
resource "aws_route_table" "RT" {
  for_each = var.route-tables
  vpc_id = aws_vpc.main["main"].id

  dynamic "route" {
    for_each = var.route-tables
    content {
      cidr_block = route.value.cidr
      tags = route.value.tags
    }
  }

}