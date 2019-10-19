resource "aws_sns_topic" "user_upload" {
  name = "uploads-topic"
}

# Terraform doesn't support email.
# https://www.terraform.io/docs/providers/aws/r/sns_topic_subscription.html
resource "aws_sns_topic_subscription" "topic_lambda" {
  topic_arn = aws_sns_topic.user_upload.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.labels_lambda.arn
}

resource "aws_sns_topic_subscription" "topic_sqs" {
  topic_arn = aws_sns_topic.user_upload.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.uploads_queue.arn
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.user_upload.arn
  policy = data.aws_iam_policy_document.sns.json
}

data "aws_iam_policy_document" "sns" {
  statement {
    actions = ["SNS:Publish"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.user_upload.arn
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        aws_s3_bucket.picture.arn
      ]
    }
  }
}
