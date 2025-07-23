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
  cidr_ipv4   = var.ssh_address_range #Limit SSH for PROD (Session Manager unavailable in AWS Labs)

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

resource "aws_vpc_security_group_ingress_rule" "extractor_sg_nodered_ingress" {
  security_group_id = aws_security_group.extractor_sg.id
  cidr_ipv4   = "0.0.0.0/0"

  description = "Nodered"
  from_port = "1880"
  to_port = "1880"
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