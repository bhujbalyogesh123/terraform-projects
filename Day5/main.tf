resource "aws_vpc" "myvpc" {
    cidr_block  = var.cidr
}

resource "aws_subnet" "mypubsub" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.1.0.0/20"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "myprivsub" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.1.16.0/20"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "myrtass1" {
  route_table_id = aws_route_table.myrt.id
  subnet_id = aws_subnet.mypubsub.id
}

resource "aws_route_table_association" "myrtass2" {
  subnet_id = aws_subnet.myprivsub.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "mysg" {
  vpc_id = aws_vpc.myvpc.id
  name = "web"

  ingress {
    description = "Http connection allowed"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH port allowed"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound traffic allowed"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "mywebsg"
  }
}

resource "aws_key_pair" "devopsshkey" {
  key_name = "devopstrainingsshky"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "testsrv" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.mypubsub.id
  key_name = aws_key_pair.devopsshkey.key_name
  vpc_security_group_ids = [aws_security_group.mysg.id]

  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = self.public_ip
    }
  }
  
  provisioner "remote-exec" {
    inline = [ 
        "echo 'Hello from the remote instnace'",
        "sudo apt update -y",
        "sudo apt-get install python3-pip -y",
        "cd /home/ubuntu",
        "sudo apt install python3-venv -y",
        "python3 -m venv .venv",
        "source .venv/bin/activate",
        "sudo pip install Flask",
        "deactivate",
        "sudo python3 app.py &"
     ]

     connection {
       type = "ssh"
       user = "ubuntu"
       private_key = file("~/.ssh/id_rsa")
       host = self.public_ip
     }
  }
}



 