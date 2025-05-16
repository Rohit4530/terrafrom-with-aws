# subnet validations
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "input" {
  for_each = toset(var.subnet_ids)
  id = each.value
  lifecycle {
    postcondition {
      condition = self.vpc_id != data.aws_vpc.default.id
      error_message = "the following subnet is part of default vpc ${self.tags.Name} of id as ${self.id}"
    }
    postcondition {
      condition = can(lower(self.tags.Access)=="private")
      error_message = "mentioned subnet is not marked as private, please make sure subnet is private "
    }
  }
}
# security group validations
data "aws_vpc_security_group_rules" "input" {
  filter {
    name = "group-id"
    values = var.security_group_ids
  }
}
data "aws_vpc_security_group_rule" "input" {
  for_each = toset(data.aws_vpc_security_group_rules.input.ids)

  security_group_rule_id = each.value

  lifecycle {
    # Validate that inbound rules only reference security groups (no CIDR blocks)
    postcondition {
      condition = (
      self.is_egress ||  # Egress rules are always allowed
      (                  # For ingress rules:
      self.cidr_ipv4 == null &&
      self.cidr_ipv6 == null &&
      self.referenced_security_group_id != null
      )
      )
      error_message = "Security Group ${self.security_group_id} contains invalid inbound rule ${self.id}: Must reference security groups (CIDR blocks not allowed)"
    }
  }
}