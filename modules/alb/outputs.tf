output "alb_listener" {
  value = aws_alb_listener.http_listener
}

output "alb_dns" {
    value = aws_alb.test.dns_name
}

output "alb_target_group" {
  value = aws_alb_target_group.app.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}