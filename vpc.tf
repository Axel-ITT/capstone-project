resource "aws_vpc" "extractor_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "extractor-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.extractor_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = var.AZ-1
  map_public_ip_on_launch=true
  
  tags = {
    Name = "Public Subnet 1"
    Type = "public"
    application = "extractor"
  }
}

resource "aws_internet_gateway" "extractor_igw" {
  vpc_id = aws_vpc.extractor_vpc.id

  tags = {
    Name = "extractor-igw"
    application = "extractor"
    description = "igw for public subnet of extractor app"
  }
}

resource "aws_route_table" "extractor_route_table" {
  vpc_id = aws_vpc.extractor_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.extractor_igw.id
  }
}

resource "aws_route_table_association" "extractor_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.extractor_route_table.id
}