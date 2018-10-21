terragrunt = {
  terraform {
    source = "github.com/made2591/my-terragrunt/modules/jenkins"

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
    paths = ["../vpc", "../security_group", "../keypair"]
  }

}

remote_state_key_vpc            = "dev/vpc/terraform.tfstate"
remote_state_key_security_group = "dev/security_group/terraform.tfstate"

jenkins_instance_ami            = "ami-0c21ae4a3bd190229"
jenkins_instance_family         = "t2.micro"
jenkins_private_key                = "~/.ssh/id_rsa.pem"