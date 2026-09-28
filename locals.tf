locals {
  sns_topic_arn = var.sns_topic_arn != "" ? var.sns_topic_arn : try(
    aws_sns_topic.this[0].arn,
    "arn:${data.aws_partition.current.partition}:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${var.sns_topic_name}",
    ""
  )

  lambda_handler = try(split(".", basename(var.lambda_source_path))[0], "notify_slack")
}