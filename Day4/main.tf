provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "srv1" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  subnet_id = "subnet-035825eefadedb804"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}