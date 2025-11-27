#!/bin/bash
# Script pour configurer PayPal en mode Live sur Heroku

APP_NAME="tubenplay-app"

echo "🚀 Configuration PayPal en mode Live"
echo "===================================="
echo ""

# Vérifier si les clés sont fournies en arguments
if [ $# -eq 3 ]; then
  CLIENT_ID=$1
  CLIENT_SECRET=$2
  MODE=$3
else
  echo "📋 Pour passer en mode Live, vous devez avoir :"
  echo "   1. Un compte PayPal Business"
  echo "   2. Les clés API Live depuis https://developer.paypal.com"
  echo ""
  echo "📍 Pour obtenir vos clés Live :"
  echo "   1. Aller sur https://developer.paypal.com"
  echo "   2. Se connecter avec votre compte PayPal Business"
  echo "   3. Dashboard → My Apps & Credentials → Live"
  echo "   4. Créer une app ou utiliser une existante"
  echo "   5. Copier le Client ID et le Secret"
  echo ""
  echo ""
  read -p "🔑 Entrez votre PayPal Client ID (Live): " CLIENT_ID
  read -p "🔐 Entrez votre PayPal Client Secret (Live): " CLIENT_SECRET
  MODE="live"
fi

# Vérifier que les clés ne sont pas vides
if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
  echo "❌ Erreur: Les clés PayPal ne peuvent pas être vides"
  exit 1
fi

echo ""
echo "⚙️  Configuration des variables d'environnement sur Heroku..."
echo ""

# Configurer PayPal en mode Live
heroku config:set PAYPAL_MODE=live --app $APP_NAME
heroku config:set PAYPAL_CLIENT_ID="$CLIENT_ID" --app $APP_NAME
heroku config:set PAYPAL_CLIENT_SECRET="$CLIENT_SECRET" --app $APP_NAME

echo ""
echo "✅ Variables PayPal configurées !"
echo ""

# Vérifier la configuration
echo "🔍 Vérification de la configuration..."
heroku config --app $APP_NAME | grep PAYPAL

echo ""
echo "🔄 Redémarrage de l'application..."
heroku restart --app $APP_NAME

echo ""
echo "✅ Configuration terminée !"
echo ""
echo "⚠️  ATTENTION : Vous êtes maintenant en mode LIVE"
echo "   Les paiements seront réels et facturés aux utilisateurs !"
echo ""
echo "🧪 Pour tester, commencez par un petit montant."
echo ""

