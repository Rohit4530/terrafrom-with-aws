locals {
  users_from_yaml = yamldecode(file("${path.module}/user-roles.yaml")).users
  role_policies = {
    readonly = [
      "ReadOnlyAccess"
    ],
    admin = [
      "AdministratorAccess"
    ],
    auditor = [
      "SecurityAudit"
    ],
    developer = [
      "AmazonVPCFullAccess",
      "AmazonEC2FullAccess",
      "AmazonRDSFullAccess"
    ]
  }
  role_policies_list = flatten([
    for role, policies in local.role_policies : [
      for policy in policies : {
        role   = role
        policy = policy
      }
    ]
  ])
}

# Password policy
resource "aws_iam_account_password_policy" "allow_temp_passwords" {
  minimum_password_length        = 8
  require_lowercase_characters   = false
  require_numbers                = false
  require_uppercase_characters   = false
  require_symbols                = false
  allow_users_to_change_password = true
  max_password_age               = 0
}

# Create users
resource "aws_iam_user" "users" {
  for_each = toset(local.users_from_yaml[*].username)
  name     = each.value
}

# Create login profiles
resource "aws_iam_user_login_profile" "this" {
  for_each = aws_iam_user.users

  user                    = each.value.name
  password_length         = 12
  password_reset_required = true
  pgp_key                 = "" # Empty means passwords will be shown in plaintext

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}

# Create roles
resource "aws_iam_role" "roles" {
  for_each           = toset(keys(local.role_policies))
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.policy_doc.json
}

# Role trust policy
data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [for user in local.users_from_yaml : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user.username}"]
      type        = "AWS"
    }
  }
}

data "aws_caller_identity" "current" {}

# Attach policies to roles - FIXED VERSION
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each = {
    for pair in local.role_policies_list : "${pair.role}-${pair.policy}" => pair
  }

  role       = aws_iam_role.roles[each.value.role].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.policy}"
}

# Output passwords
output "passwords" {
  value     = { for user, user_login in aws_iam_user_login_profile.this : user => user_login.password }
  sensitive = true
}

# Output role policies (for debugging)
output "role_policies" {
  value = local.role_policies_list
}