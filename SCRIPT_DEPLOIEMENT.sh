#!/bin/bash

# 🚀 Script de Déploiement - Tube'NPlay
# Ce script aide à configurer et déployer l'application

echo "🚀 Script de Déploiement - Tube'NPlay"
echo "======================================"
echo ""

# Couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
info() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Vérifier si Heroku CLI est installé
if ! command -v heroku &> /dev/null; then
    error "Heroku CLI n'est pas installé"
    echo "Installer avec: https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

info "Heroku CLI détecté"

# Demander le nom de l'app Heroku
read -p "Nom de votre app Heroku: " APP_NAME

if [ -z "$APP_NAME" ]; then
    error "Le nom de l'app est requis"
    exit 1
fi

echo ""
echo "📋 Checklist de Déploiement"
echo "=========================="
echo ""

# 1. Vérifier les variables d'environnement
echo "1. Vérification des variables d'environnement..."
STRIPE_PUB_KEY=$(heroku config:get STRIPE_PUBLISHABLE_KEY --app $APP_NAME 2>/dev/null)
STRIPE_SECRET_KEY=$(heroku config:get STRIPE_SECRET_KEY --app $APP_NAME 2>/dev/null)

if [ -z "$STRIPE_PUB_KEY" ]; then
    warn "STRIPE_PUBLISHABLE_KEY n'est pas configurée"
    read -p "Voulez-vous la configurer maintenant? (o/n): " CONFIGURE_STRIPE
    if [ "$CONFIGURE_STRIPE" = "o" ]; then
        read -p "Entrez votre STRIPE_PUBLISHABLE_KEY (pk_live_... ou pk_test_...): " NEW_KEY
        heroku config:set STRIPE_PUBLISHABLE_KEY="$NEW_KEY" --app $APP_NAME
        info "STRIPE_PUBLISHABLE_KEY configurée"
    fi
else
    info "STRIPE_PUBLISHABLE_KEY est configurée"
fi

if [ -z "$STRIPE_SECRET_KEY" ]; then
    warn "STRIPE_SECRET_KEY n'est pas configurée"
    read -p "Voulez-vous la configurer maintenant? (o/n): " CONFIGURE_STRIPE
    if [ "$CONFIGURE_STRIPE" = "o" ]; then
        read -p "Entrez votre STRIPE_SECRET_KEY (sk_live_... ou sk_test_...): " NEW_KEY
        heroku config:set STRIPE_SECRET_KEY="$NEW_KEY" --app $APP_NAME
        info "STRIPE_SECRET_KEY configurée"
    fi
else
    if [[ "$STRIPE_SECRET_KEY" == *"ABC123"* ]]; then
        warn "STRIPE_SECRET_KEY contient 'ABC123' - Mode simulation actif"
        echo "Pour activer les vrais paiements, configurez une vraie clé Stripe"
    else
        info "STRIPE_SECRET_KEY est configurée (mode réel)"
    fi
fi

echo ""

# 2. Vérifier la base de données
echo "2. Vérification de la base de données..."
if heroku pg:info --app $APP_NAME &> /dev/null; then
    info "Base de données détectée"
    read -p "Voulez-vous exécuter les migrations? (o/n): " RUN_MIGRATIONS
    if [ "$RUN_MIGRATIONS" = "o" ]; then
        heroku run rails db:migrate --app $APP_NAME
        info "Migrations exécutées"
    fi
else
    warn "Aucune base de données détectée"
    echo "Créer une base de données avec: heroku addons:create heroku-postgresql:mini --app $APP_NAME"
fi

echo ""

# 3. Précompiler les assets
echo "3. Précompilation des assets..."
read -p "Voulez-vous précompiler les assets? (o/n): " PRECOMPILE
if [ "$PRECOMPILE" = "o" ]; then
    heroku run rails assets:precompile --app $APP_NAME
    info "Assets précompilés"
fi

echo ""

# 4. Redémarrer l'app
echo "4. Redémarrage de l'application..."
read -p "Voulez-vous redémarrer l'app? (o/n): " RESTART
if [ "$RESTART" = "o" ]; then
    heroku restart --app $APP_NAME
    info "Application redémarrée"
fi

echo ""
echo "✅ Configuration terminée!"
echo ""
echo "📝 Prochaines étapes:"
echo "1. Tester l'application: https://$APP_NAME.herokuapp.com"
echo "2. Tester un achat avec une carte de test Stripe"
echo "3. Vérifier les logs: heroku logs --tail --app $APP_NAME"
echo ""
echo "📚 Documentation:"
echo "- Guide Stripe: GUIDE_CONFIGURATION_STRIPE.md"
echo "- Checklist: CHECKLIST_DEPLOIEMENT.md"
echo ""

