set -e x

echo "Initialising S3 Remote State"
TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY terragrunt init --terragrunt-working-dir "./s3/" 

echo "Creating S3 Bucket for blog"
TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY terragrunt apply --terragrunt-working-dir "./s3/"

BLOG_ENDPOINT="$(terragrunt output website_endpoint --terragrunt-working-dir "./s3/")"

echo "Initialising CDN Remote State"
TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY terragrunt init --terragrunt-working-dir "./cdn/" 

echo "Creating Cloudfront Distribution"
TF_VAR_ssl_cert_arn=$SSL_CERT_ARN TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY TF_VAR_parent_zone_id=$PARENT_ZONE_ID TF_VAR_origin_domain_name=$BLOG_ENDPOINT terragrunt apply --terragrunt-working-dir "./cdn/"

CDN_DOMAIN_NAME="$(terragrunt output cf_domain_name --terragrunt-working-dir "./cdn/")"

echo "Initialising DNS Remote State"
TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY terragrunt init --terragrunt-working-dir "./dns/" 

echo "Integrating DNS with Cloudfront distribution, Creating Alias Record"
TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY TF_VAR_parent_zone_id=$PARENT_ZONE_ID TF_VAR_cf_domain_name=$CDN_DOMAIN_NAME terragrunt apply --terragrunt-working-dir "./dns/"