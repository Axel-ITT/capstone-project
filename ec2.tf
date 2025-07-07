resource "aws_instance" "app_server" {
  ami = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet_1.id

  tags = {
    Name = "WebServerInstance"
  }
}
