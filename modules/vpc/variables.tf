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

# variable "private_subnets" {
#   type = map(object({
#     description = "private subnets"

#   }))
# }