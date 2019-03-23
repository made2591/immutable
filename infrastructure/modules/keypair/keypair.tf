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

resource "aws_key_pair" "bastion" {
  key_name   = "${var.env}-bastion-keypair"
  public_key = "${file(var.bastion_public_key)}"
}
