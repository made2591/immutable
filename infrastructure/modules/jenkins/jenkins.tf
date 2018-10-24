
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
  input = ["${data.terraform_remote_state.vpc.public_subnets}"]
  result_count = 1
}

resource "aws_s3_bucket" "jenkins_backup_s3_bucket_name" {
  bucket                 = "${var.jenkins_backup_s3_bucket_name}"
  acl                    = "private"
  server_side_encryption = "aws:kms"
}

resource "aws_instance" "jenkins_master" {
  ami                         = "${var.jenkins_instance_ami}"
  instance_type               = "${var.jenkins_instance_family}"
  subnet_id                   = "${random_shuffle.selected_public_subnet.result[0]}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.security_group.jenkins_sg}"]
  associate_public_ip_address = true

  key_name  = "${var.env}-jenkins-keypair"
  user_data = "${data.template_file.user_data.rendered}"

  # Add backup task to crontab
  provisioner "file" {
    connection {
      user = "ec2-user"
      host = "${aws_instance.jenkins_master.public_ip}"
      timeout = "1m"
      private_key = "${file(var.jenkins_private_key)}"
    }
    source = "templates/cron.sh"
    destination = "/home/ec2-user/cron.sh"
  }

  provisioner "remote-exec" {
    connection {
      user = "ec2-user"
      host = "${aws_instance.jenkins_master.public_ip}"
      timeout = "1m"
      private_key = "${file(var.jenkins_private_key)}"
    }
    inline = [
      "chmod +x /home/ec2-user/cron.sh",
      "/home/ec2-user/cron.sh ${var.aws_access_key} ${var.aws_secret_key} ${var.jenkins_backup_s3_bucket_name}"
    ]
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-jenkins-master",
    "Description", "EC2 Jenkins master instance",
    "Environment", "${var.env}"
  ))}"

  depends_on = ["aws_s3_bucket.jenkins_backup_s3_bucket_name"]

}
