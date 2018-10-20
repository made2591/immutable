env = "dev"
region = "eu-west-1"
availability_zones = ["a", "b"]
default_tags = {
  "ProjectName"     = "Learning"
  "Tool"            = "Terraform"
  "Scope"           = "VPC"
}
cidr_block = "172.16.0.0/22"
cidr_public_blocks = ["172.16.0.0/26", "172.16.0.64/26"]
cidr_private_blocks = ["172.16.0.128/26", "172.16.0.192/26"]