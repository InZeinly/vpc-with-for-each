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
  app_count = var.app_count
}

module "s3_bucket" {
  source = "./modules/s3bucket"
}

module "codebuild" {
  source = "./modules/codebuild"
    github_oauth_token = var.oauth
    repo_url = var.repo_url
    git_trigger_event = var.git_trigger_event
    COMMIT_MESSAGE = var.COMMIT_MESSAGE
    build_spec_file = "project/config/buildspec.yml"
}