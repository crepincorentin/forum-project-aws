#!/bin/sh

# Génère le fichier config.js avec l'URL de l'API
# Si API_URL n'est pas défini, laisse vide (JS utilisera localhost)
if [ -n "$API_URL" ]; then
  cat > /usr/share/nginx/html/config.js <<EOF
// Configuration générée au déploiement
window.API_URL = '${API_URL}';
EOF
  echo "✅ Configuration générée avec API_URL=${API_URL}"
else
  echo "// No API_URL configured, using default" > /usr/share/nginx/html/config.js
  echo "⚠️  Aucune API_URL définie, utilisation de localhost:3000 par défaut"
fi

# Démarre Nginx
exec nginx -g 'daemon off;'
