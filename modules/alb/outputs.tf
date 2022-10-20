output "alb_listener" {
  value = aws_lb_listener.http_listener.id
}

output "alb_dns" {
    value = aws_lb.test.dns_name
}