# === EC2 : Base de données PostgreSQL ===
resource "aws_instance" "db" {
  ami                    = "ami-0a854fe96e0b45e4e" # Ubuntu 22.04
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.forum_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -x
              exec > >(tee /var/log/user-data.log)
              exec 2>&1
              
              echo "Starting DB user-data script..."
              apt update -y
              apt install -y docker.io
              
              systemctl start docker
              systemctl enable docker
              sleep 10
              
              echo "Starting PostgreSQL container..."
              docker run -d \
                --name postgres \
                -e POSTGRES_USER=${var.db_user} \
                -e POSTGRES_PASSWORD=${var.db_password} \
                -e POSTGRES_DB=forum \
                -p 5432:5432 postgres:16
              
              echo "DB setup completed!"
              docker ps
              EOF

  tags = {
    Name = "forum-db-corentin"
  }
}

# === EC2 : API Node.js ===
resource "aws_instance" "api" {
  ami                    = "ami-0a854fe96e0b45e4e"
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.forum_sg.id]

  depends_on = [aws_instance.db]

  user_data = <<-EOF
              #!/bin/bash
              set -x
              exec > >(tee /var/log/user-data.log)
              exec 2>&1
              
              echo "Starting API user-data script..."
              apt update -y
              apt install -y docker.io
              
              systemctl start docker
              systemctl enable docker
              sleep 10
              
              echo "Pulling API image from Docker Hub..."
              docker pull corentin123/forum-api:${var.docker_tag}
              
              echo "Running API container..."
              docker run -d -p 3000:3000 --name api \
                -e DB_HOST=${aws_instance.db.private_ip} \
                -e DB_USER=${var.db_user} \
                -e DB_PASSWORD=${var.db_password} \
                -e DB_NAME=forum \
                -e DB_PORT=5432 \
                -e CORS_ORIGIN="*" \
                corentin123/forum-api:${var.docker_tag}
              
              echo "API setup completed!"
              docker ps
              EOF

  tags = {
    Name = "forum-api-corentin"
  }
}

# === EC2 : Front (Nginx) ===
resource "aws_instance" "front" {
  ami                    = "ami-0a854fe96e0b45e4e"
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.forum_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -x
              exec > >(tee /var/log/user-data.log)
              exec 2>&1
              
              echo "Starting user-data script..."
              apt update -y
              apt install -y docker.io
              
              systemctl start docker
              systemctl enable docker
              sleep 10
              
              echo "Pulling frontend image from Docker Hub..."
              docker pull corentin123/forum-frontend:${var.docker_tag}
              
              echo "Running container with placeholder..."
              docker run -d -p 80:80 --name frontend \
                corentin123/forum-frontend:${var.docker_tag}
              
              echo "User-data script completed!"
              docker ps
              EOF

  tags = {
    Name = "forum-front-corentin"
  }
}
