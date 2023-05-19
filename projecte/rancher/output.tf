# Ip pública Rancher 
output "ip_addr" {
  value       = aws_instance.rancher.public_ip
}

# Ip pública Rancher amb protocol
output "http_link" {
  value       = "http://${aws_instance.rancher.public_ip}"
  description = "HTTP Link Address"
}