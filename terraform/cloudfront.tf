# Cloudfront 

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-alfredbrowniii.io.s3.amazonaws.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.app_bucket_https.bucket_domain_name
    origin_id = "react.training.alfredbrowniii.io"

    s3_origin_config { 
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }

  }

  enabled = true 
  default_root_object = "index.html"

  aliases = ["react.training.alfredbrowniii.io"]
  
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "react.training.alfredbrowniii.io"

    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false 

      cookies {
        forward = "none"
      }
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    cloudfront_default_certificate = false
    ssl_support_method = "sni-only"
  }
}