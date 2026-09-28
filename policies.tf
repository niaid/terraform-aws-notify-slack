data "aws_iam_policy_document" "lambda" {
  count = var.create ? 1 : 0

  statement {
    sid       = "AllowWriteToCloudwatchLogs"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [replace("${try(aws_cloudwatch_log_group.lambda[0].arn, "")}:*", ":*:*", ":*")]
  }

  dynamic "statement" {
    for_each = var.kms_key_arn != "" ? [1] : []

    content {
      sid       = "AllowKMSDecrypt"
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = [var.kms_key_arn]
    }
  }
}