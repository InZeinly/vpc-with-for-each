provider "aws" {
    region = var.region
    shared_config_files      = ["./.aws/conf"]
    shared_credentials_files = ["./.aws/creds"]
  
}


module "vpc" {
  source = "./modules/vpc"
}