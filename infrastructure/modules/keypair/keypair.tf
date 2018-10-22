# security_groups.tf

# The configuration for this backend will be filled in by Terragrunt
terraform {
  backend "s3" {}
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.aws_credentials_path}"
  profile                 = "${var.remote_state_profile}"
}
resource "aws_key_pair" "jenkins" {
  key_name   = "${var.env}-jenkins-keypair"
  public_key = "${file(var.jenkins_public_key)}"
}