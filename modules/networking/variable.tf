variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "S3 bucket domain name"
  type        = string
}

variable "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "load_balancer_dns" {
  description = "Load balancer DNS name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "certificate_domain_validation_options" {
  description = "Certificate domain validation options"
  type        = set(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
  default = []
}
