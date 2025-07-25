provider "aws" {
    region = "us-east-1"
  
}

variable "instance_type" {
    description = "This is the default instance type value"
    type = string
    default = "t2.micro"  
}

variable "ami" {
    description = "default AMI value"
    type = string
    default = "ami-0a1235697f4afa8a4"
}

resource "aws_instance" "server1" {
    ami = var.ami
    instance_type = var.instance_type
}

output "public_ip" {
    description = "Public IP of newly created instance"
    value = aws_instance.server1.public_ip
}
