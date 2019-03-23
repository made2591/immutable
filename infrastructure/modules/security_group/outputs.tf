output "ssh-sg" {
  value = "${aws_security_group.ssh-sg.id}"
}

output "http-https-sg" {
  value = "${aws_security_group.http-https-sg.id}"
}

output "elb-http-https-sg" {
  value = "${aws_security_group.elb-http-https-sg.id}"
}
