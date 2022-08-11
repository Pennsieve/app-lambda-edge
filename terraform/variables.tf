variable "aws_account" {}

variable "content_security_policy" {}

variable "environment_name" {}

variable "service_name" {}

variable "tier" {}

variable "version_number" {}

variable "vpc_name" {}

variable "bucket" {
  default = "pennsieve-cc-lambda-functions-use1"
}

variable "runtime" {
  default = "nodejs16.x"
}

variable "uniq_id" {
  default = ""
}

locals {
  resource_name = "${var.uniq_id}${var.service_name}-${var.tier}"
}
