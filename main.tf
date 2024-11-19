# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "My_VPC"
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Public_Sub"
  }
}

# Create private subnet with unique CIDR block
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Private_Sub"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "local_ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IG"
  }
}

# Create Route Table and add route to the Internet Gateway
resource "aws_route_table" "local_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "RT"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.local_ig.id
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "local" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.local_rt.id
}

# Create a Security Group
resource "aws_security_group" "local_sg" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "SG"
  }

  # Inbound Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


