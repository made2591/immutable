output "jenkins_public_dns" {
  value = "[ ${aws_instance.jenkins_master.public_dns} ]"
}