#Create a VPC
resource "aws_vpc" "local_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "My_VPC"
    }
  
}

#create public subnet
resource "aws_subnet" "public" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.local_vpc.id
    tags = {
      Name = "Public_Subnet"
    }
  
}

#Create private subnet
resource "aws_subnet" "private" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.local_vpc.id
    tags = {
      Name = "Private_Subnet"
    }
  
}

#Create Internet gateway
resource "aws_internet_gateway" "local_ig" {
    vpc_id = aws_vpc.local_vpc.id
    tags = {
      Name = "My_IG"
    }
  
}

#create Route Table and Edit Subnet Association
resource "aws_route_table" "local_rt" {
    vpc_id = aws_vpc.local_vpc.id
    tags = {
      Name = "My_RT"
    }

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.local_ig.id
  }

}


resource "aws_route_table_association" "local" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.local_rt.id
}


#Create a security group
resource "aws_security_group" "loacl_sg" {
    vpc_id = aws_vpc.local_vpc.id
    tags = {
      Name ="My_SG"
    }

    # Inbound Rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # Outbound Rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        
    }
  
}