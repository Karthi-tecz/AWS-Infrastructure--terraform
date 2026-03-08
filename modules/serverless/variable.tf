variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of private subnets"
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda_timeout" {
  description = "Lambda function timeout"
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Lambda function memory size"
  type        = number
  default     = 128
}

variable "notification_email" {
  description = "Email for SNS notifications"
  type        = string
  default     = "admin@techhodude.co.in"
}
