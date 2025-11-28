#!/bin/bash
# Script pour configurer PayPal.me sur Heroku

APP_NAME="tubenplay-app"

echo "💳 Configuration PayPal.me"
echo "=========================="
echo ""

# Demander le lien PayPal.me
if [ $# -eq 1 ]; then
  PAYPAL_ME_LINK=$1
else
  echo "📋 Pour configurer PayPal.me, vous devez avoir :"
  echo "   1. Un compte PayPal"
  echo "   2. Un lien PayPal.me créé (ex: paypal.me/stephane)"
  echo ""
  echo "📍 Pour créer votre lien PayPal.me :"
  echo "   1. Aller sur https://www.paypal.com"
  echo "   2. Se connecter à votre compte"
  echo "   3. Aller sur https://www.paypal.com/myaccount/settings/paypalme"
  echo "   4. Créer votre lien personnalisé (ex: paypal.me/stephane)"
  echo ""
  echo ""
  read -p "🔗 Entrez votre lien PayPal.me (ex: paypal.me/stephane, sans https://): " PAYPAL_ME_LINK
fi

# Vérifier que le lien n'est pas vide
if [ -z "$PAYPAL_ME_LINK" ]; then
  echo "❌ Erreur: Le lien PayPal.me ne peut pas être vide"
  exit 1
fi

# Nettoyer le lien (enlever https:// si présent)
PAYPAL_ME_LINK=$(echo "$PAYPAL_ME_LINK" | sed 's|https://||' | sed 's|http://||')

echo ""
echo "⚙️  Configuration des variables d'environnement sur Heroku..."
echo ""

# Configurer PayPal.me
heroku config:set PAYPAL_ME_LINK="$PAYPAL_ME_LINK" --app $APP_NAME
heroku config:set PAYPAL_ME_ENABLED=true --app $APP_NAME

echo ""
echo "✅ Variables PayPal.me configurées !"
echo ""

# Vérifier la configuration
echo "🔍 Vérification de la configuration..."
heroku config --app $APP_NAME | grep PAYPAL_ME

echo ""
echo "🔄 Redémarrage de l'application..."
heroku restart --app $APP_NAME

echo ""
echo "✅ Configuration terminée !"
echo ""
echo "📋 Votre lien PayPal.me : https://$PAYPAL_ME_LINK"
echo ""
echo "💡 Exemple de lien pour abonnement VIP (9.99€) :"
echo "   https://$PAYPAL_ME_LINK/9.99"
echo ""
echo "⚠️  IMPORTANT :"
echo "   - Les paiements arrivent directement sur votre compte PayPal"
echo "   - Vous devrez activer manuellement les abonnements VIP après vérification"
echo "   - Les utilisateurs devront confirmer leur paiement avec un numéro de transaction"
echo ""

