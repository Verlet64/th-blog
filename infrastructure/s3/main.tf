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

variable "domain_name" {
  default = "tawhidhannan.co.uk"
}

module "staticsite" {
    source = "justincampbell/staticsite/aws"
    bucket = "blog.${var.domain_name}"
    domain = "${var.domain_name}"
}