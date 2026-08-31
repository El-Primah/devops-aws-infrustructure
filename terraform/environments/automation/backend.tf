terraform {
  backend "s3" {
    bucket = "comp-infrastructure"
    key    = "automation/terraform.tfstate"
    region = "eu-west-1"
  }
}

