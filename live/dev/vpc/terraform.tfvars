terragrunt = {
  terraform {
    source = "github.com/made2591/my-terragrunt/modules/vpc"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}

env = "dev"
region = "eu-west-1"
availability_zones = ["a", "b"]
default_tags = {
  "ProjectName"     = "Learning"
  "Tool"            = "Terraform"
  "Scope"           = "VPC"
}
cidr_block = "10.20.0.0/16"
cidr_public_blocks = ["10.20.40.0/20", "10.20.60.0/20"]
cidr_private_blocks = ["10.20.50.0/20", "10.20.70.0/20"]