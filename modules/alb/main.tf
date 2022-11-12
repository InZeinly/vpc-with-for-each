resource "aws_alb" "test" {
  name = "test-alb"
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnet_id
  # subnets = values(aws_subnet.public_subnet_id).*.id

  tags = {
    "Environment" = "testenv"
  }
}


resource "aws_alb_target_group" "app" {
  name = "targetGroup"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    interval = 20
    path = "/"
    timeout = 5
    matcher = 200
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}


resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.test.arn
  port = 5000
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.app.arn
  }
}