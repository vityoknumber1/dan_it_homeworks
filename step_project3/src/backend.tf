terraform {
  backend "s3" {
    bucket = "terraform-state-danit-devops5"
    key    = "viktor-kysil_project3/iac.tfstate"
    region = "eu-central-1"
  }
}