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

variable jenkins_public_key {
  type = "string"
  description= "The public key path used in Jenkins keypair"
}