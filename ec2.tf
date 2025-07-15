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
  ami = data.aws_ami.linux_2023_latest.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public[count.index].id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [ aws_security_group.extractor_sg.id ]
  key_name = "vockey"

  user_data = file(var.setup_filepath)
  root_block_device {
    volume_size           = 5    # Size in GB
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
      "mkdir .node-red"
      ]
  }

  provisioner "file" {
    source      = "${path.module}/node-red/flows.json"
    destination = "/home/ec2-user/.node-red/flows.json"
  }


  provisioner "file" {
    # Reverse proxy for http acess
    source      = "${path.module}/node-red/nodered.conf"
    destination = "/home/ec2-user/nodered.conf"
  }

  provisioner "remote-exec" {
    inline = [
      # Make scripts executable
      #"chmod +x /tmp/scripts/*.sh",
      
      # Activate reverse proxy for http acess
      "sudo systemctl restart nginx",
      
      # Modify settings.js to disable editor
      "SETTINGS_PATH='/home/ec2-user/.node-red/settings.js'",
      "sed -i 's/^.*disableEditor:.*$/    disableEditor: true,/' $SETTINGS_PATH",
      "sed -i 's/^.*httpAdminRoot:.*$/    httpAdminRoot: false,/' $SETTINGS_PATH",
      # Execute your custom script
      #"sudo /tmp/scripts/setup.sh",
      
      # Clean up
      #"rm -rf /tmp/scripts"
    ]
  }
  # Trigger recreation if instance changes
  triggers = {
    instance_id = aws_instance.web_server[count.index].id
  }

  depends_on = [aws_instance.web_server]
}
