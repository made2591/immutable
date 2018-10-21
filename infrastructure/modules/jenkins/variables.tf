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

variable remote_state_bucket {
  type = "string"
  description= "The s3 bucket used by terraform to store remote state"
}

variable remote_state_key_vpc {
  type = "string"
  description= "The s3 prefix used by terraform to store remote state of VPC"
}

variable remote_state_key_security_group {
  type = "string"
  description= "The s3 prefix used by terraform to store remote state of security groups"
}

variable jenkins_instance_ami {
  type = "string"
  description= "The jenkins instance ami id"
}

variable jenkins_instance_family {
  type = "string"
  description= "The jenkins instance family"
}

variable jenkins_private_key {
  type = "string"
  description= "The ssh private key used by ansible to configure the machine"
}