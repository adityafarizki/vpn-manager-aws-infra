resource "aws_s3_bucket" "cert_storage" {
  bucket = "vpn-cert-${local.account_id}-${local.current_region}"
}

resource "aws_s3_bucket_public_access_block" "cert_storage" {
  bucket = aws_s3_bucket.cert_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "cert_storage" {
  bucket = aws_s3_bucket.cert_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cert_storage" {
  bucket = aws_s3_bucket.cert_storage.id

  rule {
    id     = "delete-old-version"
    status = "Enabled"
    noncurrent_version_expiration {
      newer_noncurrent_versions = 1
      noncurrent_days           = 7
    }
  }
}
