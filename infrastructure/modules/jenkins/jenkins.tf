
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

data "terraform_remote_state" "security_group" {
  backend = "s3"
  config {
    bucket  = "${var.remote_state_bucket}"
    region  = "${var.region}"
    key     = "${var.remote_state_key_security_group}"
    profile = "${var.remote_state_profile}"
  }
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "random_shuffle" "selected_public_subnet" {
  input = ["${data.terraform_remote_state.vpc.public_subnets}"]
  result_count = 1
}

resource "aws_instance" "jenkins_master" {
    # Use an Ubuntu image in eu-west-1
    ami           = "${data.aws_ami.ubuntu.id}" #"${var.jenkins_instance_ami}"
    instance_type = "${var.jenkins_instance_family}"

    # We're assuming the subnet and security group have been defined earlier on
    subnet_id                   = "${random_shuffle.selected_public_subnet.result[0]}"
    vpc_security_group_ids      = ["${data.terraform_remote_state.security_group.jenkins_sg}"]
    associate_public_ip_address = true

    # We're assuming there's a key with this name already
    key_name = "${var.env}-jenkins-keypair"
    # provisioner "remote-exec" {
    #   inline = ["sudo amazon-linux-extras install -y ansible2"]

    #   connection {
    #     type        = "ssh"
    #     user        = "ubuntu"
    #     private_key = "${file(var.jenkins_private_key)}"
    #   }
    # }

    # # This is where we configure the instance with ansible-playbook
    # provisioner "local-exec" {
    #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.jenkins_private_key} master.yaml"
    # }

    tags = "${merge(var.default_tags, map(
      "Name", "${var.env}-jenkins-master",
      "Description", "EC2 Jenkins master instance",
      "Environment", "${var.env}"
    ))}"
}

resource "aws_ebs_volume" "jenkins_master_ebs_volume" {
    availability_zone = "${aws_instance.jenkins_master.availability_zone}"
    size              = 8

    tags = "${merge(var.default_tags, map(
      "Name", "${var.env}-jenkins-master-ebs",
      "Description", "EC2 Jenkins master instance EBS volume",
      "Environment", "${var.env}"
    ))}"
}

resource "aws_volume_attachment" "jenkins_master_ebs_volume_attachment" {
    device_name  = "/dev/sdh"
    instance_id  = "${aws_instance.jenkins_master.id}"
    volume_id    = "${aws_ebs_volume.jenkins_master_ebs_volume.id}"

    provisioner "remote-exec" {
        script = "remote_scripts/create_ci.sh"
        connection {
            host = "${aws_instance.jenkins_master.public_ip}"
            user = "ubuntu"
            private_key = "${file(var.jenkins_private_key)}"
        }
    }

    provisioner "remote-exec" {
        when   = "destroy"
        script = "remote_scripts/destroy_ci.sh"
        connection {
            host = "${aws_instance.jenkins_master.public_ip}"
            user = "ubuntu"
            private_key = "${file(var.jenkins_private_key)}"
        }

    }
}