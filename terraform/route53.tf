# 
# Get hosted zone Information and create a record for the domain
# 

data "aws_route53_zone" "hosted_zone" { 
  name = "alfredbrowniii.io"
}

resource "aws_route53_record" "alfredbrowniii" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name = "react.training.alfredbrowniii.io"
  type = "A"
  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
  depends_on = [
    aws_s3_bucket_website_configuration.app_bucket_https
  ]
}

resource "aws_route53_record" "cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}
  
