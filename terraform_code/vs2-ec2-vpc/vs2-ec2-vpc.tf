provider "aws" {
  profile = "cloudadmin" # aws profile
  region = "us-east-1" # or your preferred region
}

# Create VPC
resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "devops_subnet" {
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-igw"
  }
}

# Create Route Table
resource "aws_route_table" "devops_public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }
  tags = {
    Name = "devops-public-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "devops_public_subnet_association" {
  subnet_id      = aws_subnet.devops_subnet.id
  route_table_id = aws_route_table.devops_public_rt.id
}

# Create Security Group
resource "aws_security_group" "devops_sg" {
  vpc_id      = aws_vpc.devops_vpc.id
  name        = "devops-sg"
  description = "Security group for devops instances"

  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Jenkins port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define a map for the instances
locals {
  instances = {
    jenkins_master = "jenkins-master"
    jenkins_slave  = "jenkins-slave"
    ansible        = "ansible"
  }
}

# Create EC2 Instances
resource "aws_instance" "devops_instances" {
  for_each       = local.instances
  ami            = "ami-04a81a99f5ec58529" # Amazon Ubuntu AMI ID
  instance_type  = "t2.micro"
  key_name       = "devops-repos-key"
  subnet_id      = aws_subnet.devops_subnet.id
  security_groups = [aws_security_group.devops_sg.id]

  tags = {
    Name = each.value
  }
}
