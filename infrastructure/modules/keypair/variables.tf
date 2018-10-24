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

variable aws_access_key {
  type = "string"
  description= "The aws access key - content"
}

variable aws_access_secret {
  type = "string"
  description= "The aws access secret - content"
}

variable default_tags {
  type = "map"
  description= "The set of tags to propagate to every resource"
}

variable jenkins_public_key {
  type = "string"
  description= "The public key path used in Jenkins keypair"
}