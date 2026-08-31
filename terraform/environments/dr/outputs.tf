output "restored_db_endpoint" {
  value = aws_db_instance.restored_db.endpoint
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}
