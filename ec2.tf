data "aws_ami" "linux_2023_latest" {
  most_recent = true
  owners = ["amazon"] # Or specify your own account ID or other owners
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "extractor_sg" {
  name = "web-security-group"
  description = "web-security-group"
  vpc_id = aws_vpc.extractor_vpc.id

  tags = {
    Name = "web-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "extractor_sg_ssh_ingress" {
  security_group_id = aws_security_group.extractor_sg.id
  cidr_ipv4   = var.ip_address #Limit SSH for PROD (Session Manager unavailable in AWS Labs)

  description = "SSH"
  from_port = var.ssh_port
  to_port = var.ssh_port
  ip_protocol = "tcp"

  depends_on = [aws_security_group.extractor_sg]
}

resource "aws_vpc_security_group_ingress_rule" "extractor_sg_http_ingress" {
  security_group_id = aws_security_group.extractor_sg.id
  cidr_ipv4   = "0.0.0.0/0"

  description = "HTTP"
  from_port = var.http_port
  to_port = var.http_port
  ip_protocol = "tcp"

  depends_on = [aws_security_group.extractor_sg]
}

resource "aws_vpc_security_group_egress_rule" "extractor_sg_egress" {
  security_group_id = aws_security_group.extractor_sg.id
  cidr_ipv4   = "0.0.0.0/0"

  from_port = 0
  to_port = 0
  ip_protocol = "-1"

  depends_on = [aws_security_group.extractor_sg]
}

#IAM s3 fetch permission?
resource "aws_instance" "web_server" {
  count = length(var.AZ-list)
  ami = data.aws_ami.linux_2023_latest.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public[count.index].id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [ aws_security_group.extractor_sg.id ]
  key_name = "vockey"

  user_data = file(var.setup_filepath)
  tags = {
    Name = "WebServerInstance"
  }

  depends_on = [ aws_s3_object.flow ]
}

