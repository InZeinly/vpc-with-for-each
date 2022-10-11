variable "vpc" {
    type = map(object({
        cidr = string
        tags = map(string)
    }))
    default = {
      "main" = {
        cidr = "10.0.0.0/16"
        tags = {
          "Name" = "Main-Vpc"
        }
      }
    }
}

# Subnets

variable "subnets" {
  type = map(object({
    cidr = string
    tags = map(string)
  }))
  # Privates
  default = {
    "Private1" = {
      cidr = "10.0.10.0/24"
      tags = {
        "Name" = "Private1"
      }
    }
    "Private2" = {
        cidr = "10.0.20.0/24"
        tags = {
            "Name" = "Private2"
        }
    }
    #Publcs 
    "Public1" = {
        cidr = "10.0.1.0/24"
        tags = {
            "Name" = "Public1"
        }
    }
    "Public2" = {
        cidr = "10.0.2.0/24"
        tags = {
            "Name" = "Public2"
        }
    }
  }
}

# Route tables

variable "route-tables" {
  type = map(object({
    cidr_block = string
    tags  = map(string)
  }))
  default = {
    "Public1" = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Public1"
      }
    }
    "Public2" = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Public2"
      }
    }
    "Private1" = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Private1"
      }
    }
    "Private2" = {
      cidr_block = "0.0.0.0/0"
      tags = {
        "Name" = "Private2"
      }
    }
  }
}