# Random String to Ensure Unique Bucket Name
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Use a unique bucket name by appending a random suffix
locals {
  unique_bucket_name = "${var.bucket_name}-${random_string.suffix.result}"
}

# Create the bucket
resource "aws_s3_bucket" "portfolio_bucket" {
  bucket        = local.unique_bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name        = local.unique_bucket_name
    Environment = "Portfolio"
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "portfolio_bucket_versioning" {
  bucket = aws_s3_bucket.portfolio_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Ensure Block Public Access is Configured
resource "aws_s3_bucket_public_access_block" "portfolio_bucket" {
  bucket                  = aws_s3_bucket.portfolio_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "portfolio_bucket_policy" {
  bucket = aws_s3_bucket.portfolio_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.portfolio_bucket.arn}/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp": var.allowed_cidr_blocks
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "portfolio_config" {
  bucket = aws_s3_bucket.portfolio_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}
