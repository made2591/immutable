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

remote_state_key_vpc            = "prod/vpc/terraform.tfstate"
remote_state_key_security_group = "prod/security_group/terraform.tfstate"

jenkins_instance_ami            = "ami-f95ef58a"
jenkins_instance_family         = "t2.micro"
private_key_path                = "./id_rsa.pem"