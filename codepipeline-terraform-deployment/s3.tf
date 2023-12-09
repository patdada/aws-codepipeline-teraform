################################################################################
# S3 Bucket
################################################################################

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "this" {
    #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
    #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
    #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
    #checkov:skip=CKV2_AWS_61: "Ensure that an S3 bucket has a lifecycle configuration"

  bucket_prefix = "this-is-a-test-bucket-oct"
}


################################################################################
# S3 Versioning Configuration
################################################################################

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

################################################################################
# S3 Bucket server side encryption Configuration
################################################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


################################################################################
# S3 Bucket public access block
################################################################################

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = "true"
  block_public_policy     = "true"
  ignore_public_acls      = "true"
  restrict_public_buckets = "true"

}
