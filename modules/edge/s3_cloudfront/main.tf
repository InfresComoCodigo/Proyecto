resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    project     = "Villa Alfredo"
    environment = "dev"
  }
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for Villa Alfredo"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  web_acl_id = var.waf_acl_arn


  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = replace(var.api_gateway_domain, "https://", "")
    origin_id   = "api-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

ordered_cache_behavior {
  path_pattern           = "/api/*"
  target_origin_id       = "api-origin"
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["HEAD", "GET", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
  cached_methods         = ["HEAD", "GET"]

  forwarded_values {
    query_string = true
    headers      = ["*"]
    cookies {
      forward = "all"
    }
  }
}


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    project     = "Villa Alfredo"
    environment = "dev"
  }
}
