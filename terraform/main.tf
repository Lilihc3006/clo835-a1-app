provider "aws" {
  region = var.region
}

# Get default VPC and its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Amazon Linux 2023 x86_64 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ECR repositories
resource "aws_ecr_repository" "webapp_repo" {
  name = "webapp"
}

resource "aws_ecr_repository" "mysql_repo" {
  name = "mysql"
}

# Security group allowing SSH and app ports 8081-8083
resource "aws_security_group" "ec2_sg" {
  name        = "clo835_sg"
  description = "Allow SSH and app ports"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Single rule covering 8081-8083
  ingress {
    description = "App ports"
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "clo835_sg"
  }
}


# User data to install Docker on Amazon Linux 2023
locals {
  userdata = <<-EOF
              #!/bin/bash
              set -euxo pipefail
              dnf update -y
              dnf install -y docker
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user
              # Helpful tooling
              dnf install -y git
              EOF
}

# Choose first subnet in default VPC (default subnets are public by default)
locals {
  subnet_id = element(data.aws_subnets.default.ids, 0)
}

resource "aws_instance" "webserver" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  


  user_data = local.userdata

  tags = {
    Name = "CLO835-EC2"
  }
}
