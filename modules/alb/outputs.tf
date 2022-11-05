output "alb_listener" {
  value = aws_lb_listener.http_listener.id
}

output "alb_dns" {
    value = aws_lb.test.dns_name
}

output "aws_alb_target_group" {
  value = aws_lb_target_group.app.id
}