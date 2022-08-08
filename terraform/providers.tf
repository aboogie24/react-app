terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }

  }
}

provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}