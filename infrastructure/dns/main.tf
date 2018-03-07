terraform {
  backend "s3" {}
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-2"
}

variable "website_alias" {
    description = "The DNS Record "
    default = "blog.tawhidhannan.co.uk"
}

variable "parent_zone_id" {
    description = "The Parent Zone ID "
}

variable "target_zone_id" {
  description = "For a cloudfront distribution, this is always Z2FDTNDATAQYW2"
  default = "Z2FDTNDATAQYW2"
}

variable "cf_domain_name" {
  description = "The domain name for the cloudfront distribution"
}

module "production_blog" {
  source          = "git::https://github.com/cloudposse/terraform-aws-route53-alias.git?ref=master"
  aliases         = ["blog.tawhidhannan.co.uk"]
  parent_zone_id  = "${var.parent_zone_id}"
  target_dns_name = "${var.cf_domain_name}"
  target_zone_id  = "${var.target_zone_id}"
}