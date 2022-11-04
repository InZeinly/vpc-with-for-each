resource "aws_vpc" "main" {
    for_each = var.vpc
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
}


# ask about using other resource variable from for each to another one
# Creting Privates and Public
resource "aws_subnet" "subnets_pub" {
    vpc_id = aws_vpc.main["main"].id
    for_each = var.subnets_pub
    cidr_block = each.value["cidr"]
    tags = each.value["tags"]
    availability_zone = each.value["availability_zone"]
    # for_each = tostring(data.aws_availability_zones.available.names)
    # availability_zone = tostring(data.aws_availability_zones.available.names)

    depends_on = [
      aws_vpc.main
    ]
}

# Creating Publics
resource "aws_subnet" "subnets_priv" {
  vpc_id = aws_vpc.main["main"].id
  for_each = var.subnets_priv
  cidr_block = each.value["cidr"]
  tags = each.value["tags"]
  availability_zone = each.value["availability_zone"]
  
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
  subnet_id = aws_subnet.subnets_pub["Public1"].id

  tags = {
    "Name" = "nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

# Route tables
resource "aws_route_table" "RT_pub" {
  for_each = var.route-tables_pub
  tags = each.value["tags"]
  vpc_id = aws_vpc.main["main"].id

  dynamic "route" {
    for_each = var.route-tables_pub
    content {
      cidr_block = route.value.cidr_block
      gateway_id = aws_internet_gateway.igw["main"].id
    }
  }
}

resource "aws_route_table" "RT_priv" {
  for_each = var.route-tables_priv
  tags = each.value["tags"]
  vpc_id = aws_vpc.main["main"].id

  dynamic "route" {
    for_each = var.route-tables_priv
    content {
      cidr_block = route.value.cidr_block
      gateway_id = aws_nat_gateway.nat.id
      # gateway_id = aws_internet_gateway.igw["main"].id
    }
  }
}


# RT Association pub
resource "aws_route_table_association" "Pub1" {
  subnet_id = aws_subnet.subnets_pub["Public1"].id
  route_table_id = aws_route_table.RT_pub["Public1"].id
}

resource "aws_route_table_association" "Pub2" {
  subnet_id = aws_subnet.subnets_pub["Public2"].id
  route_table_id = aws_route_table.RT_pub["Public2"].id
}

resource "aws_route_table_association" "Priv1" {
  subnet_id = aws_subnet.subnets_priv["Private1"].id
  route_table_id = aws_route_table.RT_priv["Private1"].id
}

resource "aws_route_table_association" "Priv2" {
  subnet_id = aws_subnet.subnets_priv["Private2"].id
  route_table_id = aws_route_table.RT_priv["Private2"].id
}