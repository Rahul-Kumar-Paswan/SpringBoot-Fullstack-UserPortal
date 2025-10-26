variable "tags" {
  type = map(string)
}

variable "Name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_availability_zones" {
  type = list(string)
}

variable "private_subnet_availability_zones" {
  type = list(string)
}
