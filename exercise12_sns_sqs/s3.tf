resource "aws_s3_bucket" "picture" {
  bucket        = "edx-buliding-on-aws-by-terraform"
  force_destroy = true # For `terraform destroy` after taking course
}

resource "aws_s3_bucket" "artifact" {
  bucket        = "edx-buliding-on-aws-artifact-by-terraform"
  force_destroy = true # For `terraform destroy` after taking course
}
