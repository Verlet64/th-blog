terraform {
  backend "s3" {}
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

variable "parent_zone_id" {
    default = "Z6M1WX9HIPYWW"
    description = "Define this over the command line"
}

variable "cdn_name" {
    default = "blog"
}

variable "alias_records" {
    default = ["blog.tawhidhannan.co.uk"]
}

variable "stage" {
    default = "production"
}

variable "ssl_cert_arn" {
    description = "The ARN of the SSL certificate"
}

variable "origin_domain_name" {
    default = "blog.tawhidhannan.co.uk.s3-website.eu-west-2.amazonaws.com"
    description = "The endpoint for the bucket"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = "Created By Terraform"
}

resource "aws_cloudfront_distribution" "blog-tawhidhannan-cdn" { 
    origin {
        domain_name = "${var.origin_domain_name}"
        origin_id   = "tawhidhannan-production-website"
        custom_origin_config {
            origin_protocol_policy = "http-only"
            http_port = "80"
            https_port = "443"
            origin_ssl_protocols = ["TLSv1"]
        }
    }

    enabled = true
    default_root_object = "index.html"
    aliases             = "${var.alias_records}"
    price_class         = "PriceClass_100"

    default_cache_behavior {
        allowed_methods = [ "GET", "HEAD" ]
        cached_methods  = [ "GET", "HEAD" ]
        target_origin_id = "tawhidhannan-production-website"
        forwarded_values {
            query_string = true
            cookies {
                forward = "none"
            }
        }
        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
        compress = true
    }
    
    viewer_certificate {
        acm_certificate_arn = "${var.ssl_cert_arn}"
        ssl_support_method = "sni-only"
    }   

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
}