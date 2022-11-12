variable "private_subnet_id" {}

variable "alb_listener" {}

variable "iam_role" {}

variable "vpc_id" {}

variable "image_tag" {
    default = "0.0.01"
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