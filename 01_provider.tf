terraform {
  backend "s3" {
    bucket = "my-terraform-bucket01"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}


provider "aws" {
  # Configuration options
}