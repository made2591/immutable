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

# VPC definition
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-vpc",
    "Description", "VPC for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

# Internet and NAT Gateway with HA
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-default-internet-gateway",
    "Description", "Internet Gateway for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

resource "aws_eip" "nat" {
  count = "${length(var.availability_zones)}"
  vpc   = true

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-eip-nat-${element(var.availability_zones, count.index)}",
    "Description", "Elastic IP for NAT Gateway in az ${element(var.availability_zones, count.index)} for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

resource "aws_nat_gateway" "nat" {
  count         = "${length(var.availability_zones)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.default"]

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-nat-az-${element(var.availability_zones, count.index)}",
    "Description", "NAT Gateway in az ${element(var.availability_zones, count.index)} for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

# Public and Private Subnets across availability zone
resource "aws_subnet" "public-subnet" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.cidr_public_blocks, count.index)}"
  availability_zone = "${var.region}${element(var.availability_zones, count.index)}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-public-subnet-az-${element(var.availability_zones, count.index)}",
    "Description", "Public subnet in az ${element(var.availability_zones, count.index)} for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

resource "aws_subnet" "private-subnet" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(var.cidr_private_blocks, count.index)}"
  availability_zone = "${var.region}${element(var.availability_zones, count.index)}"

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-private-subnet-az-${element(var.availability_zones, count.index)}",
    "Description", "Private subnet in az ${element(var.availability_zones, count.index)} for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

# Routing tables for public and private subnets definitions
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-public-routing-table",
    "Description", "Public routing table for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

resource "aws_route_table" "private" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags = "${merge(var.default_tags, map(
    "Name", "${var.env}-private-routing-table-az-${element(var.availability_zones, count.index)}",
    "Description", "Private routing table in ${element(var.availability_zones, count.index)} for ${var.env} environment",
    "Environment", "${var.env}"
  ))}"
}

# Routing tables for public and private subnets associations
resource "aws_route_table_association" "public-subnet" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_route_table_association" "private-subnet" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.private-subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.region}.s3"
}
