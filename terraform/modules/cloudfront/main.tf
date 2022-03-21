resource "aws_cloudfront_distribution" "wordpress" {
  aliases = [
    "web.training2.yumemi.io",
  ]
  comment          = "Created using the AWS for WordPress plugin"
  enabled          = true
  http_version     = "http2"
  is_ipv6_enabled  = true
  price_class      = "PriceClass_200"
  retain_on_delete = false
  tags = {
    "createdBy" = "AWSForWordPressPlugin"
  }
  tags_all = {
    "createdBy" = "AWSForWordPressPlugin"
  }
  wait_for_deployment = true
  web_acl_id          = "arn:aws:wafv2:us-east-1:470926947163:global/webacl/CloudFront/8fe168ab-8f66-4cfa-aaf0-1d854fb83469"

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "CFWPOriginwebtraining2yumemiio"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "CloudFront-Forwarded-Proto",
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-Tablet-Viewer",
        "Host",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "comment_*",
          "wordpress_*",
          "wp-settings-*",
        ]
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    path_pattern           = "wp-content/*"
    smooth_streaming       = false
    target_origin_id       = "CFWPOriginwebtraining2yumemiio"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    path_pattern           = "wp-includes/*"
    smooth_streaming       = false
    target_origin_id       = "CFWPOriginwebtraining2yumemiio"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    path_pattern           = "wp-admin/*"
    smooth_streaming       = false
    target_origin_id       = "CFWPOriginwebtraining2yumemiio"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "*",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    path_pattern           = "wp-login.php"
    smooth_streaming       = false
    target_origin_id       = "CFWPOriginwebtraining2yumemiio"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "*",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "www.training2.yumemi.io"
    origin_id           = "CFWPOriginwebtraining2yumemiio"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "match-viewer"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:470926947163:certificate/676113f6-306b-4a15-8068-26196ccd0719"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }
}
