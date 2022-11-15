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

variable "aws_ecr_repository_url" {}

variable "alb_sg" {
  type = string
}

variable "server_image" {
    default = "152617774363.dkr.ecr.eu-central-1.amazonaws.com/testapp-testenv"
}

locals {
  image = format("%s:%s", var.aws_ecr_repository_url, var.image_tag)
}

variable "app_port" {
  default = 5000
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "web_server_fargate_cpu" {
  description = "Fargate instance CPU units to provision for web server (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "web_server_fargate_memory" {
  description = "Fargate instance memory to provision for web server (in MiB)"
  default     = 2048
}

variable "taskdef_template" {
  default = "cb_app.json.tpl"
}