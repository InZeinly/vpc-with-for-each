output "alb_listener" {
  value = aws_lb_listener.front_end.id
}

output "alb_dns" {
    value = aws_alb.test.dns_name
}