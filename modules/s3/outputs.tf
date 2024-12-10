output "bucket_name" {
  value = aws_s3_bucket.portfolio_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.portfolio_bucket.arn
}

output "bucket_region" {
  value = aws_s3_bucket.portfolio_bucket.region
}

output "bucket_policy_id" {
  description = "The ID of the S3 bucket policy."
  value       = aws_s3_bucket_policy.portfolio_bucket_policy.id
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.portfolio_config.website_endpoint
}

