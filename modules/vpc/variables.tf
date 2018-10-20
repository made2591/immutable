variable env {
  type = "string"
  description= "The environment for deployment"
}

variable region {
  type = "string"
  description= "The region used"
}

variable remote_state_profile {
  type = "string"
  description= "The profile to use inside credential for state retrieval and provider"
}

variable aws_credentials_path {
  type = "string"
  description= "The path of the credentials file in the host system"
}

variable default_tags {
  type = "map"
  default = {
      "ProjectName"     = "ApplicationName"
      "Tool"            = "Terraform"
      "Scope"           = "Learning"
  }
  description= "Tags to propagate to every resource"
}

variable availability_zones {
  type = "list"
  description= "The availability zone to be used"
}

variable cidr_block {
  type = "string"
  description= "The VPC cidr block"
}

variable cidr_public_blocks {
  type = "list"
  description= "The public subnet cidr block"
}

variable cidr_private_blocks {
  type = "list"
  description= "The private subnet cidr block"
}