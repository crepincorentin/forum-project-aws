# 💬 Forum Anonyme - Projet AWS avec CI/CD

[![CI/CD Pipeline](https://github.com/crepincorentin/forum-project-aws/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/crepincorentin/forum-project-aws/actions/workflows/ci-cd.yml)

Application de forum anonyme déployée sur AWS avec un pipeline CI/CD complet utilisant GitHub Actions, Terraform, Docker et Node.js.

## 📋 Table des matières

- [Architecture](#-architecture)
- [Technologies](#-technologies)
- [Fonctionnalités](#-fonctionnalités)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Déploiement](#-déploiement)
- [Pipeline CI/CD](#-pipeline-cicd)
- [Structure du projet](#-structure-du-projet)
- [Configuration](#-configuration)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        GitHub Actions                        │
│  Validation → Tests → Build → Deploy → Destroy (manuel)    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                         Docker Hub                           │
│  corentin123/forum-frontend:latest | forum-api:latest       │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      AWS EC2 (eu-central-1)                 │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Frontend   │  │     API      │  │   Database   │     │
│  │  Nginx:80    │◄─┤  Node.js     │◄─┤ PostgreSQL   │     │
│  │              │  │  Port 3000   │  │  Port 5432   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│         ↑                 ↑                  ↑              │
│         └─────────────────┴──────────────────┘              │
│              Security Group (forum-sg)                      │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ Technologies

### Frontend
- **Nginx** - Serveur web
- **HTML5/CSS3/JavaScript** - Interface utilisateur
- **Docker** - Conteneurisation

### Backend
- **Node.js 20** - Runtime JavaScript
- **Express** - Framework web
- **PostgreSQL 16** - Base de données
- **CORS** - Gestion cross-origin
- **Docker** - Conteneurisation

### Infrastructure & DevOps
- **Terraform** - Infrastructure as Code
- **AWS EC2** - Instances de calcul (t3.micro)
- **GitHub Actions** - CI/CD
- **Docker Hub** - Registry d'images
- **ESLint** - Linter JavaScript
- **Prettier** - Formatage de code
- **Jest** - Tests unitaires
- **Gitleaks** - Détection de secrets

## ✨ Fonctionnalités

### Application
- 📝 Publier des messages anonymes
- 👀 Afficher les messages en temps réel
- 🎨 Interface responsive et moderne
- 🔄 Rechargement automatique des messages

### Infrastructure
- 🚀 Déploiement automatique à chaque commit
- 🔒 Sécurité avec Gitleaks et npm audit
- 🐳 Images Docker versionnées avec SHA de commit
- 🌐 Configuration dynamique des URLs (pas d'IPs hardcodées)
- 📊 Terraform state management
- 🔄 Post-configuration SSH automatique
- 💥 Destruction d'infrastructure sécurisée (manuel)

## 📦 Prérequis

### Pour le développement local
- Node.js 20+
- Docker & Docker Compose
- Git

### Pour le déploiement AWS
- Compte AWS avec permissions EC2
- Terraform 1.5+
- Paire de clés SSH AWS
- Compte Docker Hub

## 🚀 Installation

### 1. Cloner le projet

```bash
git clone https://github.com/crepincorentin/forum-project-aws.git
cd forum-project-aws
```

### 2. Installation des dépendances

```bash
cd api
npm install
```

### 3. Configuration locale

Créer un fichier `.env` dans le dossier `api/` :

```env
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=votre_mot_de_passe
DB_NAME=forum
DB_PORT=5432
PORT=3000
```

### 4. Lancer avec Docker Compose

```bash
docker-compose up -d
```

L'application sera accessible sur :
- Frontend : http://localhost:8080
- API : http://localhost:3000

## 🌍 Déploiement

### Configuration des secrets GitHub

1. Allez dans **Settings → Secrets and variables → Actions**
2. Créez les secrets suivants :

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | Clé d'accès AWS |
| `AWS_SECRET_ACCESS_KEY` | Clé secrète AWS |
| `AWS_KEY_NAME` | Nom de la paire de clés SSH |
| `AWS_PRIVATE_KEY` | Contenu du fichier .pem (clé privée SSH) |
| `DOCKER_PASSWORD` | Mot de passe Docker Hub |
| `DB_USER` | Utilisateur PostgreSQL |
| `DB_PASSWORD` | Mot de passe PostgreSQL |
| `GITLEAKS_LICENSE` | *(Optionnel)* Licence Gitleaks Pro |

### Configuration des environnements GitHub

Créez deux environnements dans **Settings → Environments** :

1. **`production`** - Sans protection (déploiement automatique)
2. **`production-destroy`** - Avec "Required reviewers" (destruction sécurisée)

### Déploiement automatique

```bash
git add .
git commit -m "feat: your feature"
git push origin main
```

Le pipeline CI/CD se déclenchera automatiquement.

## 🔄 Pipeline CI/CD

Le pipeline se compose de 5 étapes :

### 1️⃣ Validation
- ✅ ESLint (qualité du code)
- ✅ Prettier (formatage)
- ✅ npm audit (vulnérabilités)
- ✅ Gitleaks (détection de secrets)

### 2️⃣ Tests
- ✅ Jest avec PostgreSQL
- ✅ Tests unitaires de l'API
- ✅ Coverage report

### 3️⃣ Build
- 🐳 Build des images Docker
- 🏷️ Tag avec SHA de commit + `latest`
- 📤 Push vers Docker Hub
- 💾 Cache GitHub Actions

### 4️⃣ Deploy
- 🏗️ Terraform init/plan/apply
- 🔧 Post-configuration SSH
- 🌐 Configuration dynamique des URLs
- 📊 Outputs des IPs publiques

### 5️⃣ Destroy (manuel)
- 💥 Destruction via workflow_dispatch
- 🔒 Nécessite validation d'un reviewer
- 🗑️ Suppression complète de l'infrastructure

## 📁 Structure du projet

```
forum-project-aws/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # Pipeline CI/CD
├── api/
│   ├── src/
│   │   ├── db.js              # Configuration PostgreSQL
│   │   ├── index.js           # Serveur Express
│   │   └── routes.js          # Routes API
│   ├── tests/
│   │   └── api.test.mjs       # Tests Jest
│   ├── Dockerfile             # Image Docker API
│   ├── package.json
│   └── .dockerignore
├── frontend/
│   ├── index.html             # Interface utilisateur
│   ├── script.js              # Logique frontend
│   ├── style.css              # Styles
│   ├── entrypoint.sh          # Configuration dynamique
│   ├── Dockerfile             # Image Docker Frontend
│   └── .dockerignore
├── terraform/
│   ├── main.tf                # Configuration Terraform
│   ├── ec2.tf                 # Instances EC2
│   ├── security_group.tf      # Règles de sécurité
│   ├── variables.tf           # Variables
│   ├── outputs.tf             # Outputs
│   └── configure.sh           # Post-configuration SSH
├── docker-compose.yml         # Dev local
├── .gitignore
├── CICD-SETUP.md              # Guide CI/CD
└── README.md                  # Ce fichier
```

## ⚙️ Configuration

### Variables Terraform

| Variable | Description | Default |
|----------|-------------|---------|
| `docker_tag` | Tag Docker (commit SHA) | `latest` |
| `db_user` | Utilisateur PostgreSQL | - |
| `db_password` | Mot de passe PostgreSQL | - |
| `key_name` | Nom de la clé SSH AWS | - |

### Variables d'environnement

#### API
- `DB_HOST` - Hôte PostgreSQL
- `DB_USER` - Utilisateur DB
- `DB_PASSWORD` - Mot de passe DB
- `DB_NAME` - Nom de la DB
- `DB_PORT` - Port PostgreSQL (5432)
- `PORT` - Port de l'API (3000)
- `CORS_ORIGIN` - Origines autorisées (ou `*`)

#### Frontend
- `API_URL` - URL de l'API (injectée dynamiquement)

## 🧪 Tests

```bash
cd api
npm test              # Lancer les tests
npm run lint          # Vérifier le code
npm run format        # Formater le code
```

## 📊 Monitoring

Après le déploiement, le pipeline affiche :
- 🌐 Frontend URL : `http://<IP_FRONTEND>`
- 🔌 API URL : `http://<IP_API>:3000`
- 🗄️ Database : Accessible uniquement via l'API

## 🔒 Sécurité

- 🔐 Secrets chiffrés dans GitHub Actions
- 🛡️ Security Group avec règles strictes
- 🔍 Scan de sécurité avec Gitleaks
- 📦 Audit npm des dépendances
- 🚫 Clés SSH exclues du dépôt
- 🌐 CORS configuré dynamiquement

## 👤 Auteur

**Corentin Crepin**
- GitHub: [@crepincorentin](https://github.com/crepincorentin)
