variable "instance_names" {
  type = map
#   default = {
#     mongodb = "t3.small"
#     redis = "t2.micro"
#     mysql = "t3.small"
#   }
}

variable "zone_id" {
  default = "Z07439021R4NQF6C9ULT9"
}

variable "hostname" {
  default = "royalreddy.co.in"
}

variable "environment" {
  # default = "dev"
}
variable "project_name" {
  default = "Robokart"
}