variable "iam_policies_url" {
    description = "The base url of all the policies location"
}

variable "iam_policy_directory" {
    default = ""
    description = "The directory of policy location"
}

variable "attach_custom_policy" {
    default = true
    description = "Boolean to attach custom policy or not"
}

variable "github_iam_token" {
    description = "The token to authencticate github repo for policies"
}

variable "iam_assume_role_policy_directory" {
    description = "The directory of the assume role policy"
}

variable "iam_role_name" {
    description = "The name of the role to be created"
}

variable "iam_role_description" {
    description = "The description of the role to be created"
}

variable "iam_policy_name" {
    default = "PolicyNameNotProvided"
    description = "The tag name of the policy to be attaced to the role"
}

variable "assume_role_account_id" {
    default = "{{AccountIdOfAssumeRoleNotProvided}}"
    description = "The id for the account whose role is to be assumed"
}

variable "stamp_letter" {
    default = "{{StampDesignationLetterNotProvided}}"
    description = "The stamp designation letter"
}
