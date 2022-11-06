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
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_cidr = module.vpc.private_subnet_id
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.vpc.vpc_id
  private_subnet_cidr = module.vpc.private_subnet_id
  alb_listener = module.alb.alb_listener
  iam_role = module.ecs.iam_role
  image_tag = var.image_tag
  app_name = "testapp"
  app_count = 1
  aws_alb_target_group = module.alb.aws_alb_target_group
}

module "s3_bucket" {
  source = "./modules/s3bucket"
}