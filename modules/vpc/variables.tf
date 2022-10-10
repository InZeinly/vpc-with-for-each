variable "main-vpc" {
  description = "main vpc"
  type = map(object({
    cidr_blocks = list(string)
  }))
  default = {
    "main" = {
      cidr_blocks = [ "10.0.0.0/16" ]
    }
  }
}