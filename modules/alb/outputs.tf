output "alb_listener" {
  value = aws_alb_listener.http_listener.id
}

output "alb_dns" {
    value = aws_alb.test.dns_name
}

output "aws_alb_target_group" {
  value = aws_alb_target_group.app.id
}