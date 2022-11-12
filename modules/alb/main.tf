resource "aws_lb" "test" {
  name = "test-lb"
  internal = false
  load_balancer_type = "application"
  # subnets = var.public_subnet_id
  subnets = values(aws_subnet.public_subnet_id).*.id

  tags = {
    "Environment" = "testenv"
  }
}


resource "aws_lb_target_group" "app" {
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


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.test.arn
  port = 5000
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}