variable "private_subnet_id" {}

variable "alb_listener" {}

variable "iam_role" {}

variable "vpc_id" {}

variable "image_tag" {
    type = string
    default = "0.0.1"
}

variable "env" {
  default = "testenv"
}

variable "app_name" {
  default = "testapp"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "alb_target_group" {}

variable "aws_ecr_repository_url" {
  default = ""
}