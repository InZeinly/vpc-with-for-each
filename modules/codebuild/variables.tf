variable "vpc_id" {}
variable "private_subnet_id" {}
variable "region" {}

variable "aws_region" {
    default = "eu-central-1"
}

variable "github_oauth_token" {
  description = "Github OAuth token with repo access permissions"
}

variable "build_spec_file" {
  default = "project/config/buildspec.yml"
}

variable "repo_url" {
  default = "https://github.com/InZeinly/vpc-with-for-each"
}

variable "COMMIT_MESSAGE" {
  default = "(test)$"
}

variable "environment" {
  default = "testenv"
}

variable "app_name" {
  default = "testapp"
}

variable "branch_pattern" {}

# variable "subnets" {
#   type        = list(string)
#   default     = priv_subnet
#   description = "The subnet IDs that include resources used by CodeBuild"
# }

locals {
  codebuild_project_name = "${var.app_name}-${var.environment}"
  description = "Codebuild for ${var.app_name} environment ${var.environment}"
}