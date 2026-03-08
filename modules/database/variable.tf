variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of private subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for database access"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "techhodude"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "TechHoDude123!"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for RDS"
  type        = number
  default     = 20
}
