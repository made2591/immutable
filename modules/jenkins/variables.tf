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

variable remote_state_bucket {
  type = "string"
  description= "The environment for deployment"
}

variable remote_state_key_vpc {
  type = "string"
  description= "The remote state of the VPC resource"
}

variable remote_state_key_security_group {
  type = "string"
  description= "The remote state of the security groups"
}

variable jenkins_instance_ami {
  type = "string"
  description= "The jenkins instance ami id"
}

variable jenkins_instance_family {
  type = "string"
  description= "The jenkins instance family"
}

variable private_key_path {
  type = "string"
  description= "The ssh private key used by ansible to configure the machine"
}