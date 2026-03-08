variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "techhodude-static"
}
