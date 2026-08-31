terraform {
  backend "s3" {
    bucket = "comp-infrastructure-prod-eu"
    key    = "replication/terraform.tfstate"
    region = "eu-west-1"
  }
}
