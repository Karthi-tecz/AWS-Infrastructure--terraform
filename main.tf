terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  
  }


# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment         = var.environment
}

# Compute Module
# module "compute" {
#   source = "./modules/compute"
  
#   vpc_id              = module.vpc.vpc_id
#   public_subnet_ids   = module.vpc.public_subnet_ids
#   private_subnet_ids  = module.vpc.private_subnet_ids
#   environment         = var.environment
#   key_name            = var.key_name
#   website_bucket     = aws_s3_bucket.website.bucket_domain_name


  
# }

# Database Module
# module "database" {
#   source = "./modules/database"
  
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   security_group_id  = module.compute.db_security_group_id
#   environment        = var.environment
# }

# # Storage Module
# module "storage" {
#   source = "./modules/storage"
  
#   domain_name = var.domain_name
#   environment = var.environment
# }

# # Serverless Module
# module "serverless" {
#   source = "./modules/serverless"
  
#   vpc_id            = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   s3_bucket_name    = module.storage.s3_bucket_name
#   environment       = var.environment
# }

# # Networking Module (Route53, CloudFront)
# module "networking" {
#   source = "./modules/networking"
  
#   domain_name           = var.domain_name
#   s3_bucket_domain_name = module.storage.s3_bucket_domain_name
#   cloudfront_domain     = module.storage.cloudfront_domain_name
#   load_balancer_dns     = module.compute.load_balancer_dns
#   environment          = var.environment
# }
