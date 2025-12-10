resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

module "s3_bucket_tfstate" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = "tf-state-${random_string.bucket_suffix.result}-${var.aws_region}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state."
  value       = module.s3_bucket_tfstate.s3_bucket_id
}
