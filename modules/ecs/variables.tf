variable "private_subnet_cidr" {}

variable "alb_listener" {}

variable "iam_role" {}

variable "vpc_id" {}

variable "image_tag" {
    default = "0.0.01"
}

variable "app_name" {
  default = "testapp"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "aws_alb_target_group" {}