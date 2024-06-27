output "public_ip_address" {
  value = aws_instance.demo_instance.public_ip
}