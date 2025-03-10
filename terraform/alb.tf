resource "aws_alb" "main" {
    name        = "ethereum-load-balancer"
    subnets         = aws_subnet.public.*.id
    security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
    name        = "ethereum-target-group"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.main.id
    target_type = "ip"
    #target_type = "instance"

    health_check {
        healthy_threshold   = "2"
        interval            = "150"
        protocol            = "HTTP"
        matcher             = "200-299"
        timeout             = "120"
        path                = var.health_check_path
        unhealthy_threshold = "5"
    }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
