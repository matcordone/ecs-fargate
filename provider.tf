terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"

}

terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket290805"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    
  }
}

resource "aws_s3_bucket" "backend_bucket" {
  bucket = "my-terraform-backend-bucket290805"
}