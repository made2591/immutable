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

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket  = "${var.remote_state_bucket}"
    region  = "${var.region}"
    key     = "${var.remote_state_key_vpc}"
    profile = "${var.remote_state_profile}"
  }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"

  config {
    bucket  = "${var.remote_state_bucket}"
    region  = "${var.region}"
    key     = "${var.remote_state_key_security_group}"
    profile = "${var.remote_state_profile}"
  }
}

data "template_file" "user_data" {
  template = "${file("templates/user_data.tpl")}"
}

resource "random_shuffle" "selected_public_subnet" {
  input        = ["${data.terraform_remote_state.vpc.public_subnets}"]
  result_count = 1
}

resource "aws_instance" "bastion_master" {
  ami                         = "${var.bastion_instance_ami}"
  instance_type               = "${var.bastion_instance_family}"
  subnet_id                   = "${random_shuffle.selected_public_subnet.result[0]}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.security_group.ssh-sg}"]
  associate_public_ip_address = true

  key_name  = "${var.env}-bastion-keypair"
  user_data = "${data.template_file.user_data.rendered}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-bastion-master",
    "Description", "EC2 Bastion master instance",
    "Environment", "${var.env}"
  ))}"
}
