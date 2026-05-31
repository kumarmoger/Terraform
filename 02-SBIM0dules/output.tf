output "public_ip" {
  value = module.my_ec2.ec2_public_ip
}

output "private_ip" {
  value = module.my_ec2.ec2_private_ip
}

output "s3_info" {
  value = module.my_s3.s3_bucket_info
}

output "ec2_info" {
  value = module.my_ec2.ec2_full_info
}
