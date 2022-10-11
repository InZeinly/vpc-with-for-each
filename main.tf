provider "aws" {
    region = var.region
    shared_config_files      = ["/home/master/.aws/conf"]
    shared_credentials_files = ["/home/master/.aws/creds"]
  
}


module "vpc" {
  source = "./modules/vpc"
}