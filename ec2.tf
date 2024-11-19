# Create a VPC
resource "aws_vpc" "devops01_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a Subnet
resource "aws_subnet" "devops01_subnet" {
  vpc_id            = aws_vpc.devops01_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

# Create Security Group
resource "aws_security_group" "management_sg" {
  name        = "management-security-group"
  description = "Allow access to management server"
  vpc_id      = aws_vpc.devops01_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["68.100.56.219/32"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision EC2 Instance for Management Server (Docker, Jenkins, Kubernetes)
resource "aws_instance" "management_server" {
  ami                         = "ami-0ea3c35c5c3284d82" # Update to valid AMI
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.devops01_subnet.id
  security_groups             = [aws_security_group.management_sg.id]
  associate_public_ip_address = true
  key_name                    = "devops"
  tags = {
    Name = "Management Server"
  }
}
