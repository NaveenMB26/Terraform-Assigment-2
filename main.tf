terraform {
  backend "s3" {
    bucket         = "my--prod-terraform-state-bucket-123"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  env = terraform.workspace

  instance_type = {
    default = "t3.micro"
    dev     = "t3.micro"
    prod    = "t3.micro"
  }
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = local.instance_type[local.env]

  tags = {
    Name        = "${local.env}-ec2-server"
    Environment = local.env
  }
}
