#
# Create Cert with certificate manager 
# 

resource "aws_acm_certificate" "cert" {
  domain_name = "alfredbrowniii.io"
  validation_method = "DNS"

  tags = { 
    Automation = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }

  subject_alternative_names = [
    "*.training.alfredbrowniii.io"
  ]
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_record : record.fqdn]
}
