terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}


module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source = "./modules/alb"
  project_name = "Test"
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_CIDR = "10.0.20.0/24"
}