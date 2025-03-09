resource "aws_cloudfront_distribution" "static_cdn" {
  depends_on = [ aws_s3_bucket.static_bucket ]

  aliases                         = []
  comment                         = null
  continuous_deployment_policy_id = null
  default_root_object             = null
  enabled                         = true
  http_version                    = "http2"
  is_ipv6_enabled                 = true
  price_class                     = "PriceClass_All"
  retain_on_delete                = false
  staging                         = false
  tags = {
    project = "aqui-express"
  }
  tags_all = {
    project = "aqui-express"
  }
  wait_for_deployment = true
  web_acl_id          = null
  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "allow-all"
    grpc_config {
      enabled = false
    }
  }
  origin {
    connection_attempts      = 2
    connection_timeout       = 10
    domain_name              = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_access_control_id = null
    origin_id                = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_path              = null
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = null
    cloudfront_default_certificate = true
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = null
  }
}

output "cdn_url" {
  value = aws_cloudfront_distribution.static_cdn.domain_name
}
