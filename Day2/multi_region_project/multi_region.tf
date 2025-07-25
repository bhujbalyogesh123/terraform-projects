provider "aws" {
    alias = "ap-south-1"
    region = "ap-south-1"
}

provider "aws" {
    alias = "ap-southeast-1"
    region = "ap-southeast-1"
}

resource "aws_instance" "server1" {
  ami = "ami-0a1235697f4afa8a4"
  instance_type = "t2.micro"
  subnet_id = "subnet-035825eefadedb804"
  key_name = "yogi_ssh_key"
  provider = "aws.ap-south-1"
}

resource "aws_instance" "server2" {
  ami = "ami-0a1235697f4afa8a4"
  instance_type = "t2.micro"
  subnet_id = "subnet-035825eefadedb804"
  key_name = "yogi_ssh_key"
  provider = "aws.ap-southeast-1"
}
