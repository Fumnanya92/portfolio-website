# Output the Portfolio URL
output "portfolio_url" {
  description = "URL of the portfolio file in the S3 bucket"
  value       = "http://${module.s3.bucket_name}.s3.${var.aws_region}.amazonaws.com/index.html"
}