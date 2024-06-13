data "aws_region" "current_region" {}

// IMPORT ACCOUNT DATA
data "terraform_remote_state" "account" {
  backend = "s3"

  config = {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/terraform.tfstate"
    region = "us-east-1"
    profile = var.aws_account
  }
}

// IMPORT VPC DATA
data "terraform_remote_state" "region" {
  backend = "s3"

  config = {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/${data.aws_region.current_region.name}/terraform.tfstate"
    region = "us-east-1"
    profile = var.aws_account
  }
}

// IMPORT LAMBDA S3 BUCKET OBJECT
data "aws_s3_object" "s3_bucket_object" {
  bucket = var.bucket
  key    = "${var.service_name}-${var.tier}-edge/${var.service_name}-${var.tier}-edge-${var.version_number}.zip"
}
