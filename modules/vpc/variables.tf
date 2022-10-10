variable "vpc" {
    type = map(object({
        cidr = string
        tags = map(string)
    }))
    default = {
      "main" = {
        cidr = "10.0.0.0/16"
        tags = {
          "key" = "Main-Vpc"
        }
      }
    }
}

# subnets

variable "subprivate" {
  type = map(object({
    cidr = string
    tags = map(string)
  }))
  default = {
    "Private1" = {
      cidr = "10.0.10.0/24"
      tags = {
        "key" = "Private1"
      }
    }
    "Private2" = {
        cidr = "10.0.20.0/24"
        tags = {
            "key" = "Private2"
        }
    }
  }
}