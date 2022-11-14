variable "aws_region" {
    description = "aws region"
}

variable "app_name" {
    description = "app name"
    default = "testapp"
}

variable "env" {
    description = "environment"
    default = "testenv"
}

variable "server_image" {
    default = "152617774363.dkr.ecr.eu-central-1.amazonaws.com/testapp-testenv"
}
