provider "aws" {
  region = "ap-south-1"
}

variable "ami" {
  description = "image for system"
}

variable "instance_type" {
  description = "instance Type for system"
}

resource "aws_instance" "testsrv" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = "subnet-035825eefadedb804"
}