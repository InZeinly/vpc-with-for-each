provider "aws" {
    region = var.region
    provider "aws" {
    shared_config_files      = ["./.aws/conf"]
    shared_credentials_files = ["./.aws/creds"]
    profile                  = "customprofile"
  
}


module "vpc" {
  source = "./modules/vpc"
}