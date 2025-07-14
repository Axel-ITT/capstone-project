// Target groups
resource "aws_lb_target_group" "target_group" {
  count = length(var.AZ-list)
  name        = "${var.project}-${var.environment}-tg-${count.index}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.extractor_vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval           = 30
    timeout            = 5
    path               = "/"
    port               = "traffic-port"
    unhealthy_threshold = 2
  }

  tags = {
    Environment = var.environment
    Name        = "${var.project}-tg-${count.index}"
    Project     = var.project
  }

}

// ALB
resource "aws_lb" "extractor_alb" {
  name                       = "${var.project}-${var.environment}-alb"
  internal                   = false
  load_balancer_type        = "application"
  security_groups           = [aws_security_group.extractor_sg.id]
  subnets                   = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Environment = var.environment
    Name        = "${var.project}-alb"
    Project     = var.project
  }
}

// Target group attachment
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = length(var.AZ-list)
  target_group_arn = aws_lb_target_group.target_group[count.index].arn
  target_id        = aws_instance.web_server[count.index].id
  port             = 80

  depends_on = [aws_lb.extractor_alb, aws_lb_target_group.target_group]
}
