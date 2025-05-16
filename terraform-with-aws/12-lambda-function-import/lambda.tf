resource "aws_lambda_function" "this" {
  description      = "A starter AWS Lambda function."
  filename         = "${path.module}/build/lambda.zip"
  function_name    = "hello-world-function"
  handler          = "index.handler"
  role             = aws_iam_role.lambda_function_role.arn
  runtime          = "nodejs18.x"
  source_code_hash = filebase64sha256("${path.module}/build/lambda.zip")
  tags = {
    "lambda-console:blueprint" = "hello-world"
  }

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/hello-world-function"
  }
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.module}/build/index.mjs"
  output_path = "${path.module}/build/lambda.zip"
}

resource "aws_iam_role" "lambda_function_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_lambda_execution.json
  name               = "hello-world-function-role-luano6ga"
  path               = "/service-role/"
}
data "aws_iam_policy_document" "assume_role_for_lambda_execution" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

}

data "aws_iam_policy_document" "lambda_execution_policy_doc" {
  statement {
    actions   = ["logs:CreateLogGroup"]
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.active.id}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.active.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/hello-world-function:*"]
  }
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "AWSLambdaBasicExecutionRole-9d82eeaf-41d0-4fa0-9757-032327a45fac"
  path        = "/service-role/"
  description = "IAM policy for Lambda function logging"
  policy      = data.aws_iam_policy_document.lambda_execution_policy_doc.json
}
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_function_role.name
}
data "aws_caller_identity" "current" {}
data "aws_region" "active" {}
resource "aws_cloudwatch_log_group" "aws_lambda_log_group" {
  name = "/aws/lambda/hello-world-function"
}
resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}



