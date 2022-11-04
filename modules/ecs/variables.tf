variable "private_subnet_cidr" {}

variable "alb_listener" {}

variable "iam_role" {}

variable "vpc_id" {}

variable "image_tag" {
    default = "0.0.01"
}