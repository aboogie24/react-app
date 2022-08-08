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
    name = aws_s3_bucket.app_bucket_https.website_domain
    zone_id = aws_s3_bucket.app_bucket_https.hosted_zone_id
    evaluate_target_health = false
  }
  depends_on = [
    aws_s3_bucket_website_configuration.app_bucket_https
  ]
}