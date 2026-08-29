output "cloudfront_url" {
  description = "HTTPS URL for the deployed static site."
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidations and operations."
  value       = aws_cloudfront_distribution.site.id
}

output "s3_bucket_name" {
  description = "Private S3 origin bucket name."
  value       = aws_s3_bucket.site.id
}
