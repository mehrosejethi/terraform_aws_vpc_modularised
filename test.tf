variable "var1" {
	type = "list"
	default = ["abc","def"]
}

variable "attach_custom_policy" {
	default = false
}

output "policy_id" {
    value = "${var.attach_custom_policy ? element(var.var1,0) : "NoPolicyAttached"}"
}