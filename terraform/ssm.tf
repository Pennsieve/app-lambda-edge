# Content Security Policy
resource "aws_ssm_parameter" "content_security_policy" {
  name  = "/${var.environment_name}/${local.resource_name}/content-security-policy"
  type  = "String"
  value = var.content_security_policy
}
