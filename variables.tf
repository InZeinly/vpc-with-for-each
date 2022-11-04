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

variable "vpc_id" {}

variable "private_subnet_id" {}