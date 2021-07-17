resource "aws_lambda_function" "listFields" {
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name = "pdfform_listFields"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.listFields"
  runtime       = "nodejs14.x"
  timeout       = 10
}

resource "aws_cloudwatch_log_group" "listFields" {
  name              = "/aws/lambda/${aws_lambda_function.listFields.function_name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "listFields" {
  api_id             = aws_apigatewayv2_api.lambda.id
  integration_uri    = aws_lambda_function.listFields.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "listFields" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /listFields"
  target    = "integrations/${aws_apigatewayv2_integration.listFields.id}"
}

resource "aws_lambda_permission" "listFields" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.listFields.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
