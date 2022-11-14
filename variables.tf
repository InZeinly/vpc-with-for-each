variable "region" {
    description = "vpc aws region"
    default = "eu-central-1"
}

variable "repo_url" {}

variable "COMMIT_MESSAGE" {}

variable "git_trigger_event" {
    type = string
    default = "PUSH"
}

variable "app_count" {
    default = 1
}

variable "github_oauth_token" {
    default = ""
}

variable "image_tag" {
    type = string
    default = "0.0.1"
}

variable "branch_pattern" {
    type = string
    default = ""
}

variable "alb_target_group" {
    type = string
    default = ""
}

variable "app_name" {
    default = "testapp"
}

variable "env" {
    default = "testenv"
}

variable "server_image" {
    default = "152617774363.dkr.ecr.eu-central-1.amazonaws.com/testapp-testenv"
}

variable "bucket" {
    type = string
    default = "inzeintestbucket2198312312"
}

variable "aws_profile" {
    default = "inzein"
}

variable "alb_sg" {
    default = ""
}