output "api_public_ip" {
  value = aws_instance.api.public_ip
}

output "db_public_ip" {
  value = aws_instance.db.public_ip
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}

output "front_public_ip" {
  value = aws_instance.front.public_ip
}
