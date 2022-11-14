resource "aws_alb" "test" {
  name = "test-alb"
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnet_id
  # subnets = values(aws_subnet.public_subnet_id).*.id
  security_groups = [aws_security_group.alb_sg.id]

  # tags = {
  #   "Environment" = "testenv"
  # }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.test.id # was arn
  port = 5000
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.app.id #was arn
  }
}

resource "aws_security_group" "alb_sg" {
  name = "alb_sg"
  vpc_id = var.vpc_id 

  tags = {
    Name = "alb_sg"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 5000
    to_port     = 5000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb_target_group" "app" {
  name = "targetGroup"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

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
