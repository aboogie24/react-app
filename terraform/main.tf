# 
# Create S3 bucket 
# 

#
# HTTPS Web bucket 
#

data "external" "get_mime_app" { 
  for_each = fileset("..//demo-app//build//", "**")
  program = ["bash", "../scripts/get_mime.sh"]
  query = {
    filepath : "../demo-app/build/${each.key}"
  }
}

data "external" "get_mime_css" { 
  for_each = fileset("..//demo-app//build//static//css", "**")
  program = ["bash", "../scripts/get_mime.sh"]
  query = {
    filepath : "../demo-app/build/static/css/${each.key}"
  }
}

data "external" "get_mime_js" { 
  for_each = fileset("..//demo-app//build//static//js", "**")
  program = ["bash", "../scripts/get_mime.sh"]
  query = {
    filepath : "../demo-app/build/static/js/${each.key}"
  }
}

data "external" "get_mime_media" { 
  for_each = fileset("..//demo-app//build//static//media", "**")
  program = ["bash", "../scripts/get_mime.sh"]
  query = {
    filepath : "../demo-app/build/static/media/${each.key}"
  }
}

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
  #content_type = "application/octet-stream"
  content_type = data.external.get_mime_app[each.key].result.mime
}


resource "aws_s3_object" "static_css" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  for_each = fileset("..//demo-app//build//static//css", "*")
  key = "static/css/${each.value}"
  source = "..//demo-app//build//static//css//${each.value}"
  content_type = data.external.get_mime_css[each.key].result.mime
}

resource "aws_s3_object" "static_js" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  for_each = fileset("..//demo-app//build//static//js", "*")
  key = "static/js/${each.value}"
  source = "..//demo-app//build//static//js//${each.value}"
  #content_type = "application/octet-stream"
  content_type = data.external.get_mime_js[each.key].result.mime
}

resource "aws_s3_object" "static_media" {
  bucket = aws_s3_bucket.app_bucket_https.id 
  for_each = fileset("..//demo-app//build//static//media", "*")
  key = "static/media/${each.value}"
  source = "..//demo-app//build//static//media//${each.value}"
  #content_type = "application/octet-stream"
  content_type = data.external.get_mime_media[each.key].result.mime
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    effect = "Allow"

    sid = "AddPerm"
    principals {
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