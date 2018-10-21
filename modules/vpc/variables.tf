variable env {
  type = "string"
  description= "The environment of deployment"
}

variable region {
  type = "string"
  description= "The region used for deployment"
}

variable remote_state_profile {
  type = "string"
  description= "The credential profile to use for by AWS provider and remote state"
}

variable aws_credentials_path {
  type = "string"
  description= "The path of the credentials file in the host system"
}

variable default_tags {
  type = "map"
  description= "The set of tags to propagate to every resource"
}

variable availability_zones {
  type = "list"
  description= "The availability zones to be used for deployment"
}

variable cidr_block {
  type = "string"
  description= "The VPC cidr block"
}

variable cidr_public_blocks {
  type = "list"
  description= "The public subnet cidr blocks"
}

variable cidr_private_blocks {
  type = "list"
  description= "The private subnet cidr blocks"
}