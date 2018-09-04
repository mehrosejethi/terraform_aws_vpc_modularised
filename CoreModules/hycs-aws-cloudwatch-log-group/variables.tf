variable "cloudwatch_log_name" {
    description = "The name for the cloudwatch log group to be created"
}

variable "cloudwatch_retention_days" {
    description = "No. of days for cloudwatch to hold logs"
}

variable "cloudwatch_subscription_filter_name"{
    description = "Name of the subscription filter"
}

variable "cloudwatch_filter_pattern" {
    description = "The pattern for cloudwatch subscription filter"
}

variable "cloudwatch_filter_destination_arn" {
    description = "The destination arn of the cloudwatch logs"
}