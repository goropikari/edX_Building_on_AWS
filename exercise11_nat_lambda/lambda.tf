resource "aws_lambda_function" "labels_lambda" {
  filename      = "lambda_function.zip" # dummy function for terraform
  function_name = "labels-lambda"
  role          = aws_iam_role.labels-lambda.arn
  handler       = "lambda_function.lambda_handler"

  runtime = "python3.6"
  vpc_config {
    subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  timeout = 3
  environment {
    variables = {
      DATABASE_HOST     = aws_db_instance.default.address
      DATABASE_USER     = var.db_username
      DATABASE_DB_NAME  = aws_db_instance.default.name
      DATABASE_PASSWORD = var.db_password
    }
  }

  lifecycle {
    ignore_changes = ["filename", "last_modified"]
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.labels_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.picture.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.picture.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.labels_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "photos/"
  }
}
