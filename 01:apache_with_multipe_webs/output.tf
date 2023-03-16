output "ip_ec2" {
  value = aws_instance.hosting.public_ip
}