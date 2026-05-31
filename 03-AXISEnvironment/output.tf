output "public_ip" {
  value = aws_instance.kumar.public_ip
}

output "private_ip" {
  value = aws_instance.kumar.private_ip
}

output "ec2_full_info" {
  value = aws_instance.kumar
}