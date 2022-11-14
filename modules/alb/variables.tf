# variable "public_subnet_id" {}

variable "vpc_id" {}

variable "private_subnet_cidr" {}

variable "public_subnet_id" {
  default = ""
  }

  variable "server_image" {
    default = "152617774363.dkr.ecr.eu-central-1.amazonaws.com/testapp-testenv"
}