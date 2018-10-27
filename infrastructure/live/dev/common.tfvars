env = "dev"
region = "eu-west-1"
availability_zones = ["a"]
default_tags = {
  "ProjectName"     = "Learning"
  "Tool"            = "Terraform"
  "Scope"           = "VPC"
}

cidr_block = "172.16.0.0/22"
cidr_public_blocks = ["172.16.0.0/26"]
cidr_private_blocks = ["172.16.0.128/26"]

remote_state_bucket  = "made2591.terraform"
remote_state_profile = "made2591-terraform"