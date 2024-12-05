resource "aws_s3_bucket" "inbound_files" {
  bucket = "inbound-files-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Inbound Files Bucket"
    Environment = "Dev"
    Project     = "PersonalProject"
  }
}

output "inbound_files_bucket_arn" {
  value = aws_s3_bucket.inbound_files.arn
  description = "ARN of the inbound files bucket"
}

