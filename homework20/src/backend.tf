provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-danit-devops5"
    key    = "viktor-kysil/iac.tfstate"
    region = "eu-central-1"
  }
}