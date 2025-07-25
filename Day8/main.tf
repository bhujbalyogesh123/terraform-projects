provider "aws" {
    region = "ap-south-1" 
}

import {
  id = "i-01d86a8ab43d38f9a"
  to = aws_instance.example
}