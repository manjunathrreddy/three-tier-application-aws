terraform {

  required_version = "~>1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.1.0"
    }
  }




  backend "s3" {
    bucket         = "terraform-remote-version-tfstate"
    key            = "terraform-remote-version.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-remote-version-tfstate-lock"
    //profile        = "manjunathrreddy"
  }
}




locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}


provider "aws" {
  region = var.aws_region
  //profile = "manjunathrreddy"
}


data "aws_region" "current" {}
