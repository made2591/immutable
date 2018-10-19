variable env {
  type = "string"
  description= "The environment for deployment"
}

variable region {
  type = "string"
  description= "Tag to propagate to every resource"
}

variable availability_zones {
  type = "list"
  description= "The availability zone to be used"
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

variable cidr_public_blocks {
  type = "list"
  description= "The public subnet cidr block"
}

variable cidr_private_blocks {
  type = "list"
  description= "The private subnet cidr block"
}