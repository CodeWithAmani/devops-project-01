provider "aws" {
  profile = "cloudadmin"
}

resource "aws_security_group" "vs1_ec2_sg" {
  name        = "vs1ec2-sg"
  description = "Security group for vs1-ec2"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vs1_ec2" {
  ami           = "ami-01fccab91b456acc2" # (replace with the AMI ID for your region)
  instance_type = "t2.micro"
  security_groups = [aws_security_group.vs1_ec2_sg.name]

  tags = {
    Name = "vs1-ec2"
  }
}
