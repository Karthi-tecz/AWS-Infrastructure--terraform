# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "${var.environment}-hosted-zone"
  }
}

# Route53 Record for Root Domain (A Record - CloudFront)
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront hosted zone ID
    evaluate_target_health = false
  }
}

# Route53 Record for WWW (A Record - CloudFront)
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# Route53 Record for API subdomain (A Record - Load Balancer)
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.load_balancer_dns
    zone_id                = "Z35SXDOTRQ7X7K" # ELB hosted zone ID for us-east-1
    evaluate_target_health = true
  }
}

# SSL Certificate Validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in var.certificate_domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}
