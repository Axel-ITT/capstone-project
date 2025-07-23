data "aws_ami" "linux_2023_latest" {
  most_recent = true
  owners = ["amazon"] # Or specify your own account ID or other owners
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

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

resource "null_resource" "flows_transfer" {
  count = length(var.AZ-list)

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/${var.key_path}")
    host        = aws_instance.web_server[count.index].public_ip
  }

  # Wait for instance to be ready
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for instance to be ready...'",
      "mkdir .node-red",
      ]
  }

  provisioner "file" {
    source      = "${path.module}/node-red/${count.index}/flows.json"
    destination = "/home/ec2-user/.node-red/flows.json"
  }

  provisioner "file" {
    source      = "${path.module}/node-red/settings.js"
    destination = "/home/ec2-user/.node-red/settings.js"
  }

  # Trigger recreation if instance changes
  triggers = {
    instance_id = aws_instance.web_server[count.index].id
  }

  depends_on = [aws_instance.web_server]
}
