output "role_id" {
    value = "${aws_iam_role.iam_role.id}"
}

output "policy_id" {
    value = "${var.attach_custom_policy ? element(concat(aws_iam_role_policy.iam_policy_attach.*.id, list("")), 0) : "NoPolicyAttached"}"
}

output "role_arn" {
    value = "${aws_iam_role.iam_role.arn}"
}