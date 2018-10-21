output "jenkins_keypair" {
  value = "${aws_key_pair.jenkins.key_name}"
}
