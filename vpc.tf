resource "aws_vpc" "extractor_vpc" {
  cidr_block = "10.0.0.0/25"
  
  tags = {
    Name = "extractor-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.AZ-list)
  vpc_id = aws_vpc.extractor_vpc.id
  cidr_block = cidrsubnet("10.0.0.0/27", 1, count.index)
  availability_zone = var.AZ-list[count.index]
  map_public_ip_on_launch=true
  
  tags = {
    Name = "public-subnet-${count.index}"
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

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.extractor_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.extractor_igw.id
  }
}