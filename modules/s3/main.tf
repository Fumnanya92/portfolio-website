resource "aws_s3_bucket" "portfolio_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Name        = var.bucket_name
    Environment = "Portfolio"
  }
}

resource "aws_s3_bucket_versioning" "portfolio_bucket_versioning" {
  bucket = aws_s3_bucket.portfolio_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

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
