# S3 Bucket for Static Website
resource "aws_s3_bucket" "website" {
  bucket = "techhodude-static-website-${random_string.bucket_suffix.result}"

  tags = {
    Name = "${var.environment}-website-bucket"
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}
resource "website" "bucket_domain_name"{}
# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website]
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
# Variable for website folder path (Windows path)
variable "website_folder_path" {
  description = "Path to the website files folder"
  type        = string
  default     = "C:/Users/Karthi/Documents/techo/dudetech/"  # Your Windows folder
}

# Upload website files
resource "aws_s3_object" "website_files" {
  for_each = fileset(var.website_folder_path, "**")
  
  bucket       = aws_s3_bucket.website.id
  key          = each.value
  source       = "${var.website_folder_path}${each.value}"
  content_type = lookup(local.content_types, regex("\\\\.[^.]+$", each.value), "application/octet-stream")
  etag         = filemd5("${var.website_folder_path}${each.value}")
}

# Content type mapping
locals {
 content_types = {
  ".html"     = "text/html"
  ".css"      = "text/css"
  ".js"       = "application/javascript"
  ".map"      = "application/json"
  ".png"      = "image/png"
  ".jpg"      = "image/jpeg"
  ".jpeg"     = "image/jpeg"
  ".gif"      = "image/gif"
  ".svg"      = "image/svg+xml"
  ".ico"      = "image/x-icon"
  ".json"     = "application/json"
  ".xml"      = "application/xml"
  ".txt"      = "text/plain"
  ".pdf"      = "application/pdf"
  ".zip"      = "application/zip"
  ".webp"     = "image/webp"
  ".woff"     = "font/woff"
  ".woff2"    = "font/woff2"
  ".ttf"      = "font/ttf"
}
}



# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.environment}-s3-oac"
  description                       = "OAC for S3 website bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
    origin_id                = "S3-${aws_s3_bucket.website.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.website.bucket}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = "${var.environment}-cloudfront"
  }
}

# SSL Certificate
resource "aws_acm_certificate" "website" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.environment}-ssl-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}
