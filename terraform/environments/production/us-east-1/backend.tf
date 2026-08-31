terraform {
  backend "s3" {
    bucket = "comp-infrastructure-prod"
    key    = "us-east-1/terraform.tfstate"
    region = "us-east-1"
  }
}

