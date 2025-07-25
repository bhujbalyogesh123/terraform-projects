terraform {
  backend "s3" {
    bucket = "mytestbucketfordevops23012025"
    region = "ap-south-1"
    key = "folder1/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}