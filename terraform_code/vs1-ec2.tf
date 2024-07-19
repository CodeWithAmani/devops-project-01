provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "vs1-ec2" {
    ami = "ami-022e1a32d3f742bd8"
    instance_type = "t2.micro"
    key_name = "dpp"
    security_groups = [ "vs1-ec2-sg" ]
}

resource "aws_security_group" "vs1-ec2-sg" {
  name        = "vs1-ec2-sg"
  description = "use SSH Access"
  
  ingress {
    description      = "Shh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "vs1-ec2-port"

  }
}