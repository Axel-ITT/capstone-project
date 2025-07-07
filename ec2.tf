data "aws_ami" "linux_2023_latest" {
  most_recent = true
  owners = ["amazon"] # Or specify your own account ID or other owners
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "security-group" {

    name = "terraform-security-group"
    vpc_id = aws_vpc.extractor_vpc.id
    ingress  {
        description = "SSH"
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        description = "HTTP"
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        description = "HTTPS"
        from_port = var.https_port
        to_port = var.https_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "app_server" {
  ami = data.aws_ami.linux_2023_latest.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet_1.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [ aws_security_group.security-group.id ]
  key_name = "vockey"


  user_data = file(var.wordpress_setup_filepath)
  tags = {
    Name = "WebServerInstance"
  }
}
