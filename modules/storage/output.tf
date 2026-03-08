output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "cloudfront_domain_name" {
  description = "Domain name of CloudFront distribution"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID of CloudFront distribution"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

output "certificate_arn" {
  description = "ARN of the SSL certificate"
  value       = aws_acm_certificate.website.arn
}

output "certificate_domain_validation_options" {
  description = "Domain validation options for the certificate"
  value       = aws_acm_certificate.website.domain_validation_options
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.website.bucket_domain_name
}

