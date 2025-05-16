data "aws_iam_policy_document" "oidc_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/app.terraform.io"]
    }

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:rg_devops_4530:project:terrafrom_oidc_connect:workspace:terraform-cli:run_phase:*"]
    }
  }
}
resource "aws_iam_role" "role_for_oidc" {
  name               = "terrafrom-cloud-automation-admin"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role.json
}
data "aws_iam_policy" "admin" {
  arn= "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_role_policy_attachment" "admin_access" {
  role       = aws_iam_role.role_for_oidc.name
  policy_arn = data.aws_iam_policy.admin.arn
}
data "tls_certificate" "terraform_cloud_crt" {
  url = "https://app.terraform.io"
}

locals {
  oidc_thumbprints = [
    for cert in data.tls_certificate.terraform_cloud_crt.certificates : cert.sha1_fingerprint
  ]
}

resource "aws_iam_openid_connect_provider" "default" {
  client_id_list = ["aws.workload.identity"]

  thumbprint_list = local.oidc_thumbprints

  url = data.tls_certificate.terraform_cloud_crt.url

  tags = {
    Name = "Terraform-cloud"
  }

  tags_all = {
    Name = "Terraform-cloud"
  }
}
data "aws_caller_identity" "current" {}