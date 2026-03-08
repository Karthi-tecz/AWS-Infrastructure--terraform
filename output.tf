# # VPC Outputs
# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = module.vpc.vpc_id
# }

# output "public_subnet_ids" {
#   description = "IDs of public subnets"
#   value       = module.vpc.public_subnet_ids
# }

# output "private_subnet_ids" {
#   description = "IDs of private subnets"
#   value       = module.vpc.private_subnet_ids
# }

# # Compute Outputs
# output "load_balancer_dns_name" {
#   description = "DNS name of the Application Load Balancer"
#   value       = module.compute.load_balancer_dns
# }

# output "load_balancer_url" {
#   description = "URL of the Application Load Balancer"
#   value       = "http://${module.compute.load_balancer_dns}"
# }

# # Database Outputs
# output "database_endpoint" {
#   description = "RDS instance endpoint"
#   value       = module.database.db_instance_endpoint
#   sensitive   = true
# }

# # Storage Outputs
# output "s3_bucket_name" {
#   description = "Name of the S3 bucket"
#   value       = module.storage.s3_bucket_name
# }

# output "cloudfront_domain_name" {
#   description = "CloudFront distribution domain name"
#   value       = module.storage.cloudfront_domain_name
# }

# output "website_url" {
#   description = "Website URL"
#   value       = "https://${var.domain_name}"
# }

# # Serverless Outputs
# output "lambda_function_name" {
#   description = "Name of the Lambda function"
#   value       = module.serverless.lambda_function_name
# }

# output "sns_topic_arn" {
#   description = "SNS topic ARN"
#   value       = module.serverless.sns_topic_arn
# }

# output "sqs_queue_url" {
#   description = "SQS queue URL"
#   value       = module.serverless.sqs_queue_url
# }

# # Networking Outputs
# output "hosted_zone_id" {
#   description = "Route53 hosted zone ID"
#   value       = module.networking.hosted_zone_id
# }

# output "name_servers" {
#   description = "Route53 name servers"
#   value       = module.networking.hosted_zone_name_servers
# }

# # URLs and Access Points
# output "application_endpoints" {
#   description = "Application endpoints"
#   value = {
#     website     = "https://${var.domain_name}"
#     www_website = "https://www.${var.domain_name}"
#     api         = "https://api.${var.domain_name}"
#     alb_direct  = "http://${module.compute.load_balancer_dns}"
#   }
# }

# # Infrastructure Summary
# output "infrastructure_summary" {
#   description = "Summary of deployed infrastructure"
#   value = {
#     region                = var.aws_region
#     environment          = var.environment
#     domain               = var.domain_name
#     vpc_cidr            = var.vpc_cidr
#     availability_zones   = var.availability_zones
#     components_deployed  = [
#       "VPC with public/private subnets",
#       "Application Load Balancer",
#       "Auto Scaling Group",
#       "RDS MySQL Database",
#       "S3 + CloudFront CDN",
#       "Lambda Functions",
#       "SNS + SQS messaging",
#       "Route53 DNS",
#       "CloudWatch Monitoring",
#       "SSL Certificate"
#     ]
#   }
# }
