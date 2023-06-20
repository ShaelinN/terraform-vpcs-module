/*terraform {
  backend "s3" {
    bucket         = "nshaelin-terraform-state"
    key            = "terraform.tfstate"
    region         = "af-south-1"
    dynamodb_table = "nshaelin-terraform-lock"
  }
}
*/
/*
provider "aws" {
  region = var.aws_region

  profile = var.aws_profile
}*/

data "aws_ami" "al2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  cidr               = var.vpc_cidr
  azs                = [var.availability_zone]
  public_subnets     = [var.public_subnet_cidr]
  private_subnets    = [var.private_subnet_cidr]
  enable_nat_gateway = true
  name               = "sn-vpc-${var.environment_name}"
}

resource "aws_subnet" "isolated_subnet" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.isolated_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "${module.vpc.name}-isolated-${var.availability_zone}"
  }
}

resource "aws_instance" "private_ec2" {
  subnet_id     = module.vpc.private_subnets[0]
  instance_type = "t3.micro"
  ami           = data.aws_ami.al2.id

  tags = {
    Name = "sn-${var.environment_name}-server"
  }
}