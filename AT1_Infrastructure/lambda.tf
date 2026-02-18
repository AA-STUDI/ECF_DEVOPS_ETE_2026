data "archive_file" "lambda_login" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "login" {
  function_name    = "infoline-login-function"
  
  filename         = data.archive_file.lambda_login.output_path

  runtime          = "nodejs20.x"
  handler          = "index.handler"
  
  source_code_hash = data.archive_file.lambda_login.output_base64sha256
  
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "lambda_login" {
  name              = "/aws/lambda/${aws_lambda_function.login.function_name}"
  retention_in_days = 7
}

resource "aws_iam_role" "lambda_exec" {
  name = "infoline-lambda-login-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}