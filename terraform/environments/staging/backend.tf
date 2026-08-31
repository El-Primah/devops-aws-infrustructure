terraform {
  backend "s3" {
    bucket = "comp-infrastructure"
    key    = "staging/terraform.tfstate"
    region = "eu-west-1"
  }
}

