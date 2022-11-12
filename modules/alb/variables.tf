# variable "public_subnet_id" {}

variable "vpc_id" {}

variable "private_subnet_cidr" {}

variable "public_subnet_id" {
  default = aws_subnet.subnets_pub.id
}