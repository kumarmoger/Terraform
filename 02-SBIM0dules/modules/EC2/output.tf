output "ec2_public_ip" {
  value = aws_instance.kumar.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.kumar.private_ip
}

output "ec2_full_info" {
  value = aws_instance.kumar

}