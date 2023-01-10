resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "example-public-subnet"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.example.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "subnetass" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
      Name        = "example-security-group"
      Environment = "production"
  }              
}


resource "aws_instance" "web" {
 ami = "ami-03f8756d29f0b5f21" 
 associate_public_ip_address = true 
 instance_type = "t2.micro"  
 
 subnet_id = aws_subnet.public.id
 vpc_security_group_ids = ["${aws_security_group.example.id}"]
 
 user_data = "${file("nginx_config.sh")}"
   
 tags = {
   Name = "web-server"  
 }
 }