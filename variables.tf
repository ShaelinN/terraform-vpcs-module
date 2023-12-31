variable "aws_region" {
  default = "af-south-1"
}

variable "availability_zone" {
  default = "af-south-1a"
}

variable "environment_name" {

}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "isolated_subnet_cidr" {
  default = "10.0.3.0/24"
}

