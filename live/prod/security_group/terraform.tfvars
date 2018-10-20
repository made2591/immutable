terragrunt = {
  terraform {
    source = "github.com/made2591/my-terragrunt/modules/security_group"

    extra_arguments "vars_loading" {
      commands  = ["${get_terraform_commands_that_need_vars()}"]
      arguments = [
        "-var-file=${get_tfvars_dir()}/../common.tfvars",
        "-var-file=terraform.tfvars"
      ]
    }

  }

  include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc"]
  }

}

remote_state_key_vpc = "prod/vpc/terraform.tfstate"