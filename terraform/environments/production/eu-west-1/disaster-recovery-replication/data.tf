data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "comp_prod_eu" {
  backend = "s3"

  config = {
    bucket = "comp-infrastructure-prod-eu"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

locals {
  genomic_docs_id = data.terraform_remote_state.comp_prod_eu.outputs.genomic_docs_id

  user_bl_item_id = data.terraform_remote_state.comp_prod_eu.outputs.user_bl_item_id
}
