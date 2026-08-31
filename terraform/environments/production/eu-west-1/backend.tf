terraform {
  backend "s3" {
    bucket = "comp-infrastructure-prod-eu"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
