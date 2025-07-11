// Target groups
resource "aws_lb_target_group" "target_group" {
  count = length(var.AZ-list)
  name     = "target-group-${count.index}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.extractor_vpc.id
}


// Target group attachment
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = length(var.AZ-list)
  target_group_arn = aws_lb_target_group.target_group[count.index].arn
  target_id        = aws_instance.web_server[count.index].id
  port             = 80
}

// ALB
resource "aws_lb" "extractor_alb" {
  name               = "extractor-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.extractor_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Environment = "dev"
    Name = "Extractor ALB"
  }
}
