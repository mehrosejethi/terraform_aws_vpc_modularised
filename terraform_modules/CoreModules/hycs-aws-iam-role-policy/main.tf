data "http" "iam_policy" {
  url = "${var.iam_policies_url}/${var.iam_policy_directory}"
  
  request_headers {
    "Authorization" = "token ${var.github_iam_token}"
    "Accept" = "application/json"
  }

  count = "${var.attach_custom_policy ? 1 : 0}"
}

data "http" "iam_assume_role_policy" {
  url = "${var.iam_policies_url}/${var.iam_assume_role_policy_directory}"
  
  request_headers {
    "Authorization" = "token ${var.github_iam_token}"
    "Accept" = "application/json"
  }
}

resource "aws_iam_role" "iam_role" {
  name = "${var.iam_role_name}"
  description = "${var.iam_role_description}"
  
  assume_role_policy = "${data.http.iam_assume_role_policy.body}"
}

resource "aws_iam_role_policy" "iam_policy_attach" {
  name        = "${var.iam_policy_name}"
  role		    = "${aws_iam_role.iam_role.id}"
  policy	    = "${replace(replace(data.http.iam_policy.0.body, "{{AccountID}}", var.assume_role_account_id), "{{STAMP}}", var.stamp_letter)}"

  count = "${var.attach_custom_policy ? 1 : 0}"
}