
// Listener
resource "aws_lb_listener" "extractor_alb_listener" {
  load_balancer_arn = aws_lb.extractor_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
}

resource "aws_lb_listener_rule" "rule_b" {
 listener_arn = aws_lb_listener.extractor_alb_listener.arn
 priority     = 60

 action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.target_group[1].arn
 }

 condition {
   path_pattern {
     values = ["/images*"]
   }
 }
}

#resource "aws_lb_listener_rule" "rule_c" {
# listener_arn = aws_lb_listener.extractor_alb_listener.arn
# priority     = 40
#
# action {
#   type             = "forward"
#   target_group_arn = aws_lb_target_group.target_group[2].arn
# }
#
# condition {
#   path_pattern {
#     values = ["/register*"]
#   }
# }
#}