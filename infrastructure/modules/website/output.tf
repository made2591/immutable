output "Elastic Load Balancer IP" {
  value = "${aws_elb.website-elb.dns_name}"
}
