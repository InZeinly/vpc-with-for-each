# terraform {
#   backend "s3" {
#     bucket = "inzeintestbucket"
#     encrypt = true
#     dynamodb_table = "terraform_state_lock"
#     key    = "terraform.tfstate"
#     region = "eu-central-1"
#   }
# } 