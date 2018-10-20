output "ssh_sg" {
  value = "${aws_security_group.ssh-sg.id}"
}

output "jenkins_sg" {
  value = "${aws_security_group.jenkins-sg.id}"
}