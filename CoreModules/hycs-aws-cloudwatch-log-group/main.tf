resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name 				= "${var.cloudwatch_log_name}"
  retention_in_days = "${var.cloudwatch_retention_days}"
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_subscription_filter" {
  name            = "${var.cloudwatch_subscription_filter_name}"
  log_group_name  = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"
  filter_pattern  = "${var.cloudwatch_filter_pattern}"
  destination_arn = "${var.cloudwatch_filter_destination_arn}"
}