# CREATE LAMBDA FUNCTION
resource "aws_lambda_function" "lambda_function" {
  function_name     = "${var.environment_name}-${local.resource_name}-${data.terraform_remote_state.region.outputs.aws_region_shortname}"
  description       = "Add headers to incoming requests."
  role              = aws_iam_role.lambda_iam_role.arn
  handler           = "app.handler"
  publish           = "true"
  runtime           = var.runtime
  s3_bucket         = data.aws_s3_object.s3_bucket_object.bucket
  s3_key            = data.aws_s3_object.s3_bucket_object.key
  s3_object_version = data.aws_s3_object.s3_bucket_object.version_id
  timeout           = 30

  # Edge lambda functions cannot have environment variables
}

# CREATE LAMBDA FUNCTION WARMER PERMISSION
resource "aws_lambda_permission" "warmer_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudwatch_event_rule.arn
  statement_id  = "AllowExecutionFromCloudwatchEvents"
}
