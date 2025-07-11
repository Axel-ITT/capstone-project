data "aws_ami" "linux_2023_latest" {
  most_recent = true
  owners = ["amazon"] # Or specify your own account ID or other owners
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "security-group" {

    name = "web-security-group"
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
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "web-security-group"
  }
}

resource "aws_instance" "web_server" {
  count = length(var.AZ-list)
  ami = data.aws_ami.linux_2023_latest.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public[count.index].id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [ aws_security_group.security-group.id ]
  key_name = "vockey"


  user_data = file(var.setup_filepath)
  tags = {
    Name = "WebServerInstance"
  }
}
