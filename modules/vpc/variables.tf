variable "main_vpc" {
    type = set(string)
    default = [ "10.0.0.0/16" , "20.0.0.0/16"]
}