provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami = "ami-0a1235697f4afa8a4"
  instance_type = "t2.micro"
  subnet_id = "subnet-035825eefadedb804"
  key_name = "yogi_ssh_key"
}
