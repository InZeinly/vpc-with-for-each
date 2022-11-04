variable "vpc_id" {}
variable "private_subnet_id" {}
variable "region" {}

variable "aws_region" {
    description = "aws region"
}

variable "github_oauth_token" {
  description = "Github OAuth token with repo access permissions"
}

variable "build_spec_file" {
  default = "project/config/buildspec.yml"
}

variable "repo_url" {
  default = "https://github.com/InZeinly/vpc-with-for-each/tree/main/project"
}

variable "COMMIT_MESSAGE" {
  default = "(test)$"
}