################################################################################
# Set required providers and version
################################################################################

terraform {
  backend "s3" {
    bucket = "terraform-state-storage20231207201209834200000002" 
    region = "eu-west-2"
    key    = "global/s3/terraform.tfstate"
    dynamodb_table = "terraform-state-storage"
    encrypt        = true
    kms_key_id     = "alias/terraform-state-storage"

  }
   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}


################################################################################
# S3 Bucket
################################################################################

#resource "aws_s3_bucket" "this" {
#  bucket_prefix = "this-is-a-test-bucket-with-a-name-that-is-way-to-long-why"
#}

