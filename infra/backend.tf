terraform {
  backend "s3" {
    bucket = "niletask" 
    key    = "terraform.tfstate"
    region = "eu-north-1"
    profile= "my_account"
  }
}