resource "aws_s3_bucket" "restricted_files" {
  bucket = "restricted-files-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Restricted Files Bucket"
    Environment = "Dev"
    Project     = "PersonalProject"
  }
}

output "restricted_files_bucket_arn" {
  value = aws_s3_bucket.restricted_files.arn
  description = "ARN of the restricted files bucket"
}
