variable "private_subnet_id" {
  default = ""
}

variable "alb_listener" {
  default = ""
}

variable "iam_role" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

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

variable "alb_target_group" {
  default = ""
}

variable "aws_ecr_repository_url" {
  default = ""
}

variable "alb_sg" {
  type = string
}

variable "server_image" {
    default = "152617774363.dkr.ecr.eu-central-1.amazonaws.com/testapp-testenv"
}