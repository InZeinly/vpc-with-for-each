provider "aws" {
    region = "eu-central-1"
  
}


module "vpc" {
  source = "./modules/vpc"
}

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# output "list_of_az" {
#   value = data.aws_availability_zones.available[*].names
# }