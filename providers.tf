terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key       # Referenced from Jenkins credentials
  secret_key = var.aws_secret_key       # Referenced from Jenkins credentials
}

variable "aws_access_key" {
  description = "AWS Access Key"
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  default     = ""
}
