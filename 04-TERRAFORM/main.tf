#create custom vpc
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "custom_vpc"
  }
}


#create custom subnet
resource "aws_subnet" "custom_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "custom_subnet"
  }
}

#create custom internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "my_igw"
  }
}

#route table creation
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "my_rt"
  }
}

#route table association to subnet
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.custom_subnet.id
  route_table_id = aws_route_table.rt.id
}

#create security group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_sg"
  }
}


#creating ec2 instance 
resource "aws_instance" "kumar" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.custom_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "my_ec2"
  }
}
