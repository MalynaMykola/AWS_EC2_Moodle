provider "aws" {
  region     = var.region
  shared_credentials_file = "~/.aws/credentials"
}

terraform {
  backend "s3" {
    bucket         = "terraformbackendmyproject"
    region         = "eu-central-1"
    dynamodb_table = "terraform"
    key            = "terraform.tfstate"
   # shared_credentials_file = "~/.aws/credentials"
  }
}