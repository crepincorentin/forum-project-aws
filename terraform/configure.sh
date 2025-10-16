#!/bin/bash
# Script de post-configuration pour injecter les URLs dynamiques

set -e

echo "🔧 Configuration post-déploiement..."

# Récupérer les IPs depuis Terraform outputs
API_IP=$(terraform output -raw api_public_ip)
FRONT_IP=$(terraform output -raw front_public_ip)
DB_IP=$(terraform output -raw db_public_ip)

echo "📍 IPs détectées:"
echo "  Frontend: $FRONT_IP"
echo "  API: $API_IP"
echo "  DB: $DB_IP"

# Attendre que les instances soient prêtes
echo "⏳ Attente de 60s pour que les instances démarrent..."
sleep 60

# Reconfigurer le frontend avec l'IP de l'API
echo "🎨 Reconfiguration du frontend..."
ssh -o StrictHostKeyChecking=no -i ~/.ssh/${KEY_NAME}.pem ubuntu@$FRONT_IP << EOF
  sudo docker stop frontend || true
  sudo docker rm frontend || true
  sudo docker run -d -p 80:80 --name frontend \
    -e API_URL=http://$API_IP:3000 \
    corentin123/forum-frontend:${DOCKER_TAG}
  echo "✅ Frontend reconfiguré avec API_URL=http://$API_IP:3000"
EOF

# Reconfigurer l'API avec le CORS du frontend
echo "🔌 Reconfiguration de l'API CORS..."
ssh -o StrictHostKeyChecking=no -i ~/.ssh/${KEY_NAME}.pem ubuntu@$API_IP << EOF
  sudo docker stop api || true
  sudo docker rm api || true
  sudo docker run -d -p 3000:3000 --name api \
    -e DB_HOST=$(terraform output -raw db_private_ip || echo $DB_IP) \
    -e DB_USER=${DB_USER} \
    -e DB_PASSWORD=${DB_PASSWORD} \
    -e DB_NAME=forum \
    -e DB_PORT=5432 \
    -e CORS_ORIGIN=http://$FRONT_IP \
    corentin123/forum-api:${DOCKER_TAG}
  echo "✅ API reconfigurée avec CORS_ORIGIN=http://$FRONT_IP"
EOF

echo ""
echo "✅ Configuration terminée!"
echo "🌐 Frontend: http://$FRONT_IP"
echo "🔌 API: http://$API_IP:3000"
echo "🗄️  DB: $DB_IP:5432"
