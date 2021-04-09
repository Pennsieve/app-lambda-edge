# CREATE LAMBDA IAM ROLE
resource "aws_iam_role" "lambda_iam_role" {
  name = "${var.environment_name}-${local.resource_name}-role-${data.terraform_remote_state.region.outputs.aws_region_shortname}"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "edgelambda.amazonaws.com",
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# CREATE LAMBDA IAM POLICY
resource "aws_iam_policy" "lambda_iam_policy" {
  name   = "${var.environment_name}-${local.resource_name}-policy-${data.terraform_remote_state.region.outputs.aws_region_shortname}"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_iam_policy_document.json
}

# ATTACH LAMBDA IAM POLICY
resource "aws_iam_role_policy_attachment" "lambda_iam_role_policy_attachment" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
}

# CREATE LAMBDA IAM POLICY DOCUMENT
data "aws_iam_policy_document" "lambda_iam_policy_document" {
  statement {
    sid       = "LambdaInvocation"
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"]
  }

  statement {
    sid    = "CloudwatchLogPermissions"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutDestination",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "SSM"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current_region.name}:${data.terraform_remote_state.account.outputs.aws_account_id}:parameter/${var.environment_name}/${local.resource_name}/*",
    ]
  }
}
