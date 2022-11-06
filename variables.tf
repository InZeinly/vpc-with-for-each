variable "region" {
    description = "vpc aws region"
    default = "eu-central-1"
}

# variable "oauth" {}

variable "repo_url" {}

variable "COMMIT_MESSAGE" {}

variable "git_trigger_event" {
    type = string
    default = "PUSH"
}

variable "app_count" {
    default = 1
}

variable "github_oauth_token" {}

# variable "vpc_id" {}

variable "private_subnet_id" {}

# variable "github_oauth_token" {
#     default = 
# }

variable "image_tag" {
    default = "0.0.1"
}