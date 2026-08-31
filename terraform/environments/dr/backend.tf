terraform {
  backend "s3" {
    bucket = "comp-infrastructure-disaster-recovery"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
