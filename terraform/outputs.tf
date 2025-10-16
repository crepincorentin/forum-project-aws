output "api_public_ip" {
  value = aws_instance.api.public_ip
}

output "db_public_ip" {
  value = aws_instance.db.public_ip
}

output "front_public_ip" {
  value = aws_instance.front.public_ip
}
