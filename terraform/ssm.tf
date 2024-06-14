# Content Security Policy
resource "aws_ssm_parameter" "content_security_policy_script" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/script"
  type  = "String"
  value = var.content_security_policy_script
}

resource "aws_ssm_parameter" "content_security_policy_style" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/style"
  type  = "String"
  value = var.content_security_policy_style
}

resource "aws_ssm_parameter" "content_security_policy_worker" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/worker"
  type  = "String"
  value = var.content_security_policy_worker
}

resource "aws_ssm_parameter" "content_security_policy_img" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/img"
  type  = "String"
  value = var.content_security_policy_img
}

resource "aws_ssm_parameter" "content_security_policy_font" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/font"
  type  = "String"
  value = var.content_security_policy_font
}

resource "aws_ssm_parameter" "content_security_policy_media" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/media"
  type  = "String"
  value = var.content_security_policy_media
}

resource "aws_ssm_parameter" "content_security_policy_frame" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/frame"
  type  = "String"
  value = var.content_security_policy_frame
}

resource "aws_ssm_parameter" "content_security_policy_connect" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy/connect"
  type  = "String"
  value = var.content_security_policy_connect
}
