resource "aws_sqs_queue" "uploads_queue" {
  name = "uploads-queue"
}

resource "aws_sqs_queue_policy" "default" {
  queue_url = aws_sqs_queue.uploads_queue.id
  policy    = data.aws_iam_policy_document.sqs.json
}

data "aws_iam_policy_document" "sqs" {
  statement {
    sid     = "sid1"
    effect  = "Allow"
    actions = ["SQS:SendMessage"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sqs_queue.uploads_queue.arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        aws_sns_topic.user_upload.arn
      ]
    }
  }
}

output "sqs_url" {
  value = aws_sqs_queue.uploads_queue.id
}
