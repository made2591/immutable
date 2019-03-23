output "bastion_keypair" {
  value = "${aws_key_pair.bastion.key_name}"
}
