terragrunt = {
  terraform {
    source = "github.com/made2591/my-terragrunt/modules/keypair"

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

}

jenkins_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDvmxzN+Y8oajlU4vq5Z9CqYIVuw+g1YhfLc1ET3A4Q8wo22vi6I5CpfmMQyaGlc1AI6o4UDsEQQ426EX//VjiB7MPwptIBwNaOdpvyIR/mmiXkxpggjl5TCP0uK6CdPKgBVV7bl9ZvIBPEhN5bZhJ+wf2ikx5LK8r/ptwGUFveBRl20lwPvOo2QL0ClO7c9XgQ6U1tWedOfM90s/m/jO2elQ0T8XtudVJDDxvgWu4R1Bl0xCIp435zCqRXov3EuQFFnGuRNOIw1Fr7qZWqFtMYEz9Bt+JZxfeHXq3flQegdrTWSiz8GK9kLs1d0vtBod3F5j48C8KqtdGh9BlQTCeZ matteo@youngguy.local"
