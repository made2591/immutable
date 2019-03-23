variable env {
  type        = "string"
  description = "The environment of deployment"
}

variable region {
  type        = "string"
  description = "The region used for deployment"
}

variable availability_zones_fullname {
  type        = "list"
  description = "The availability zones fullname used for deployment"
}

variable remote_state_profile {
  type        = "string"
  description = "The credential profile to use for by AWS provider and remote state"
}

variable default_tags {
  type        = "map"
  description = "The set of tags to propagate to every resource"
}

variable remote_state_bucket {
  type        = "string"
  description = "The s3 bucket used by terraform to store remote state"
}

variable remote_state_key_vpc {
  type        = "string"
  description = "The s3 prefix used by terraform to store remote state of VPC"
}

variable remote_state_key_security_group {
  type        = "string"
  description = "The s3 prefix used by terraform to store remote state of security groups"
}

variable website_instance_ami {
  type        = "string"
  description = "The website instances ami id"
}

variable website_instance_family {
  type        = "string"
  description = "The website instances family"
}
