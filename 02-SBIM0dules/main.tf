module "my_ec2" {
  source = "./modules/EC2"
}

module "my_s3" {
  source = "./modules/S3"

}
