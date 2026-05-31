resource "aws_s3_bucket" "kumarmg_01" {
    bucket = var.bucket_name
    acl= "private"

    versioning {
        enabled= true
    }
}