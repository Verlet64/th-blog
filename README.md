# Layout

## Infrastructure

./infrastructure contains the Terraform (and Terragrunt) configuration for standing up an S3 bucket, with a Cloudfront distribution and the Route 53 configurtion required to set up the routing for the Cloudfront distribution. 

The entire blog is setup up using the stand-up.sh script within the CI environment.

## Blog

The blog itself is built from Hugo templates within th-blog. 
