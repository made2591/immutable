variable env {
  type = "string"
  description= "The environment for deployment"
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

variable cidr_block {
  type = "string"
  description= "The VPC cidr block"
}


variable region {
  type = "string"
  description= "The environment for deployment"
}

variable remote_state_bucket {
  type = "string"
  description= "The environment for deployment"
}

variable remote_state_key_vpc {
  type = "string"
  description= "The environment for deployment"
}

variable remote_state_key_security_group {
  type = "string"
  description= "The environment for deployment"
}

variable remote_state_profile {
  type = "string"
  description= "The environment for deployment"
}
