variable "pr_number" {
  description = "The pull request number for dynamic environment naming."
  type        = number
}

resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

module "example_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = "pr-${var.pr_number}-${random_string.bucket_suffix.result}-${var.aws_region}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket created for the PR environment."
  value       = module.example_s3_bucket.s3_bucket_id
}
