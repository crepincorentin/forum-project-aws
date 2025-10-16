#!/bin/sh

# Génère le fichier config.js avec l'URL de l'API
cat > /usr/share/nginx/html/config.js <<EOF
// Configuration générée au déploiement
window.API_URL = '${API_URL:-http://localhost:3000}';
EOF

echo "✅ Configuration générée avec API_URL=${API_URL:-http://localhost:3000}"

# Démarre Nginx
exec nginx -g 'daemon off;'
