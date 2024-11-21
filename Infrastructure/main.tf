terraform {
  backend "s3" {
    bucket         = "sl11me-terraform"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
  }
}