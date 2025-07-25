resource "aws_vpc" "mytestvpc" {
    cidr_block = var.cidr
}

resource "aws_subnet" "mypubsub" {
    vpc_id = aws_vpc.mytestvpc.id
    cidr_block = "10.1.0.0/20"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true  
}

resource "aws_subnet" "myprivsub" {
    vpc_id = aws_vpc.mytestvpc.id
    cidr_block = "10.1.16.0/20"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.mytestvpc.id  
}

resource "aws_route_table" "myRT" {
    vpc_id = aws_vpc.mytestvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table_association" "myrtass1" {
  subnet_id = aws_subnet.mypubsub.id
  route_table_id = aws_route_table.myRT.id
}

resource "aws_route_table_association" "myrtass2" {
    subnet_id = aws_subnet.myprivsub.id
    route_table_id = aws_route_table.myRT.id
}

resource "aws_security_group" "websg" {
    name = "web"
    vpc_id = aws_vpc.mytestvpc.id

    ingress {
        description = "allowing HTTP connection"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "outbound traffic allowing here"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web-SG"
    }
}

resource "aws_s3_bucket" "mys3bucketexample" {
    bucket = "myterraformtestingexamplebucket21072025"
}

resource "aws_instance" "websrv1" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.websg.id]
    subnet_id = aws_subnet.mypubsub.id
    user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "websrv2" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.websg.id]
    subnet_id = aws_subnet.myprivsub.id
    user_data = base64encode(file("userdata1.sh"))
}

# create load balancer
resource "aws_lb" "myweblb" {
  name = "myweblb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.websg.id]
  subnets = [aws_subnet.mypubsub.id, aws_subnet.myprivsub.id]

  tags = {
    Name = "Web"
  }
}

resource "aws_lb_target_group" "tg" {
    name = "myTG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.mytestvpc.id

    health_check {
      path = "/"
      port = "traffic-port"
    }
}

resource "aws_lb_target_group_attachment" "attach1" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.websrv1.id
    port = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.websrv2.id
    port = 80
}

resource "aws_lb_listener" "lblst" {
    load_balancer_arn = aws_lb.myweblb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      target_group_arn = aws_lb_target_group.tg.arn
      type = "forward"
    }
}

output "loadbalancerdns" {
  value = aws_lb.myweblb.dns_name
}

