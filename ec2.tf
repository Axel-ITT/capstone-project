#data "aws_ami" "linux_2023_latest" {
#  most_recent = true
#  owners = ["amazon"] # Or specify your own account ID or other owners
#  filter {
#    name   = "name"
#    values = ["al2023-ami-*-x86_64"]
#  }
#}

resource "aws_instance" "web_server" {
  count = length(var.AZ-list)
  ami = var.ami_id #data.aws_ami.linux_2023_latest.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public[count.index].id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [ aws_security_group.extractor_sg.id ]
  key_name = "vockey"

  user_data = file(var.setup_filepath)
  root_block_device {
    volume_size           = 10    # Size in GB
    volume_type          = "gp3"  # GP3 is the current generation
    encrypted            = true
    delete_on_termination = true
    tags = {
      Name = "Root Volume"
    }
  }

  tags = {
    Name = "WebServerInstance"
  }

  # depends_on = [ aws_s3_object.flow ]
}
