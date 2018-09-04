output "cloudwatch_log_group_name" {
    value = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"
}

output "cloudwatch_log_group_id" {
    value = "${aws_cloudwatch_log_group.cloudwatch_log_group.id}"
}

output "cloudwatch_subscription_filter_id" {
    value = "${aws_cloudwatch_log_subscription_filter.cloudwatch_subscription_filter.id}"
}