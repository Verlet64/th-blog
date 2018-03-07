output "cf_domain_name" {
    value = "${aws_cloudfront_distribution.blog-tawhidhannan-cdn.domain_name}"
}