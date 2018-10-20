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
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket  = "${var.remote_state_bucket}"
    region  = "${var.region}"
    key     = "${var.remote_state_key_vpc}"
    profile = "${var.remote_state_profile}"
  }
}

resource "aws_security_group" "ssh-sg" {
  name = "${var.env}-ssh-sg"
  description = "Security group to enable ssh"
  
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-ssh-sg",
    "Description", "Security group to enable ssh",
    "Environment", "${var.env}"
  ))}"
}

resource "aws_security_group" "jenkins-sg" {
  name = "${var.env}-jenkins-sg"
  description = "Security group to let jenkins work and let work with jenkins"
  
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-jenkins-sg",
    "Description", "Security group to enable ssh",
    "Environment", "${var.env}"
  ))}"
}