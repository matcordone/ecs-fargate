resource "aws_alb" "alb_ecs" {
  name               = "alb-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.subnet_pub1.id, aws_subnet.subnet_pub2.id]

  enable_deletion_protection = false

  tags = {
    Name = "ALB-ECS"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_1.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "ALB-Target-Group"
  }
}
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb_ecs.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
  depends_on = [ aws_alb_target_group.alb_target_group ]
}