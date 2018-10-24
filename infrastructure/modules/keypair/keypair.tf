# keypair.tf

# The configuration for this backend will be filled in by Terragrunt
terraform {
  backend "s3" {}
}

provider "aws" {
  region     = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  profile    = "${var.remote_state_profile}"
}
resource "aws_key_pair" "jenkins" {
  key_name   = "${var.env}-jenkins-keypair"
  public_key = "${file(var.jenkins_public_key)}"
}