terragrunt = {
  terraform {
    source = "github.com/made2591/immutable/infrastructure/modules/bastion"

    extra_arguments "vars_loading" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      arguments = [
        "-var-file=${get_tfvars_dir()}/../common.tfvars",
        "-var-file=terraform.tfvars",
      ]
    }
  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc", "../security_group", "../keypair"]
  }
}

remote_state_key_vpc = "prod/vpc/terraform.tfstate"

remote_state_key_security_group = "prod/security_group/terraform.tfstate"

bastion_instance_ami = "ami-0c21ae4a3bd190229"

bastion_instance_family = "t2.micro"
