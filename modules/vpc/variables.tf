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

variable "subnets_priv" {
  type = map(object({
    cidr = string
    az = string
    tags = map(string)
  }))
  # Privates
  default = {
    "Private1" = {
      cidr = "10.0.10.0/24"
      az = "eu-central-1a"
      tags = {
        "Name" = "Private1"
      }
    }
    "Private2" = {
        cidr = "10.0.20.0/24"
        az = "eu-central-1b"
        tags = {
            "Name" = "Private2"
        }
    }
  }
}

variable "subnets_pub" {
  type = map(object({
    cidr = string
    az = string
    tags = map(string)
  }))
    #Publcs 
  default = {
    "Public1" = {
        cidr = "10.0.1.0/24"
        az = "eu-central-1a"
        tags = {
            "Name" = "Public1"
        }
    }
    "Public2" = {
        cidr = "10.0.2.0/24"
        az = "eu-central-1b"
        tags = {
            "Name" = "Public2"
        }
    }
  }
}

# Route tables

variable "route-tables_pub" {
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
  }
}
# Private rt
variable "route-tables_priv" {
  type = map(object({
    cidr_block = string
    tags  = map(string)
  }))
  default = {
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