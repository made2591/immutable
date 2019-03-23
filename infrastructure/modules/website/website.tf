# vpc.tf

provider "aws" {
  region     = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  profile    = "${var.remote_state_profile}"
}

# The configuration for this backend will be filled in by Terragrunt
terraform {
  backend "s3" {}
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

resource "aws_launch_configuration" "website-launch-config" {
  name_prefix = "${var.env}-web-"

  ami                         = "${var.website_instance_ami}"
  instance_type               = "${var.website_instance_family}"
  associate_public_ip_address = true
  key_name                    = "${var.env}-website-keypair"

  security_groups             = ["${data.terraform_remote_state.security_group.http-https-sg}"]
  associate_public_ip_address = true

  user_data = "${data.template_file.user_data.rendered}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-website-launch-config",
    "Description", "Launch configuration of website module",
    "Environment", "${var.env}"
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "website-elb" {
  name = "${var.env}-website-elb"

  security_groups = ["${data.terraform_remote_state.security_group.elb-http-https-sg}"]

  subnets = ["${data.terraform_remote_state.vpc.public_subnets}"]

  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-website-elb",
    "Description", "Elastic Load Balancer of website module",
    "Environment", "${var.env}"
  ))}"
}

resource "aws_autoscaling_group" "website-autoscaling-group" {
  name = "${aws_launch_configuration.website-launch-config.name}-asg"

  min_size         = 1
  desired_capacity = 2
  max_size         = 3

  health_check_type = "ELB"

  load_balancers = ["${aws_elb.website-elb.id}"]

  launch_configuration = "${aws_launch_configuration.website-launch-config.name}"
  availability_zones   = "${var.availability_zones_fullname}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances",
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.public_subnets}"]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-website-elb",
    "Description", "Autoscaling Group of website module",
    "Environment", "${var.env}"
  ))}"
}
