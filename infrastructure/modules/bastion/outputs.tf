output "bastion_public_dns" {
  value = "[ ${aws_instance.bastion_master.public_dns} ]"
}
