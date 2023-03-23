output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "Nom de domini del load balancer"
}