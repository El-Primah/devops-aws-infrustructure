terraform {
  backend "s3" {
    bucket = "comp-infrastructure-config"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
