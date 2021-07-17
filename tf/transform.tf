resource "aws_lambda_function" "transform" {
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name = "pdfform_transform"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.transform"
  runtime       = "nodejs14.x"
  timeout       = 10
}

resource "aws_cloudwatch_log_group" "transform" {
  name              = "/aws/lambda/${aws_lambda_function.transform.function_name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "transform" {
  api_id             = aws_apigatewayv2_api.lambda.id
  integration_uri    = aws_lambda_function.transform.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "transform" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "POST /transform"
  target    = "integrations/${aws_apigatewayv2_integration.transform.id}"
}

resource "aws_lambda_permission" "transform" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transform.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
