resource "aws_lb" "overlay_alb" {
  name               = "overlay-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id] # Both subnets
}


resource "aws_lb_target_group" "frontend_tg" {
  name        = "frontend-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "ip"

  health_check {
    path = "/config"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.overlay_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}