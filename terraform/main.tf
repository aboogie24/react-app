# 
# Create S3 bucket 
# 

#
# HTTPS Web bucket 
#

resource "aws_s3_bucket" "app_bucket_https" {
  bucket = "react.training.alfredbrowniii.io"
}

resource "aws_s3_bucket_acl" "app_bucket_https" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  acl = "public-read"
}

# resource "aws_s3_bucket_object" "object" {
#   bucket = aws_s3_bucket.app_bucket_https.id
#   key = "react-app"
#   source = "../demo-app/build/*"
# }

resource "aws_s3_object" "app_bucket_https" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  for_each = fileset("..//demo-app//build/", "*")
  key = each.value
  source = "..//demo-app//build//${each.value}"
}


resource "aws_s3_object" "static_css" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  for_each = fileset("..//demo-app//build//static//css", "*")
  key = "static/css/${each.value}"
  source = "..//demo-app//build//static//css//${each.value}"
}

resource "aws_s3_object" "static_js" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  for_each = fileset("..//demo-app//build//static//js", "*")
  key = "static/js/${each.value}"
  source = "..//demo-app//build//static//js//${each.value}"
}

resource "aws_s3_object" "static_media" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  for_each = fileset("..//demo-app//build//static//media", "*")
  key = "static/media/${each.value}"
  source = "..//demo-app//build//static//media//${each.value}"
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    effect = "Allow"

    sid = "AddPerm"
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::react.training.alfredbrowniii.io/*"]

  }
}

resource "aws_s3_bucket_policy" "app_bucket_https" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  policy = data.aws_iam_policy_document.allow_public_access.json
}

resource "aws_s3_bucket_website_configuration" "app_bucket_https" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  index_document { 
    suffix = "index.html"
  }
}