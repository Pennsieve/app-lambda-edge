variable "aws_account" {}

variable "content_security_policy_script" {}
variable "content_security_policy_style" {}
variable "content_security_policy_worker" {}
variable "content_security_policy_img" {}
variable "content_security_policy_font" {}
variable "content_security_policy_media" {}
variable "content_security_policy_frame" {}
variable "content_security_policy_connect" {}


variable "environment_name" {}

variable "service_name" {}

variable "tier" {}

variable "version_number" {}

variable "vpc_name" {}

variable "bucket" {
  default = "pennsieve-cc-lambda-functions-use1"
}

variable "runtime" {
  default = "nodejs20.x"
}

variable "uniq_id" {
  default = ""
}

locals {
  resource_name = "${var.uniq_id}${var.service_name}-${var.tier}"
}
