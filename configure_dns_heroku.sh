#!/bin/bash
# Script pour configurer un domaine personnalisé sur Heroku

APP_NAME="tubenplay-app"

echo "🌐 Configuration DNS sur Heroku"
echo "================================="
echo ""

# Demander le nom de domaine
if [ $# -eq 1 ]; then
  DOMAIN=$1
else
  read -p "🌍 Entrez votre domaine (ex: www.tubenplay.com ou tubenplay.com): " DOMAIN
fi

if [ -z "$DOMAIN" ]; then
  echo "❌ Erreur: Le domaine ne peut pas être vide"
  exit 1
fi

echo ""
echo "📋 Étape 1 : Ajout du domaine sur Heroku..."
echo ""

# Ajouter le domaine sur Heroku
heroku domains:add "$DOMAIN" --app $APP_NAME

if [ $? -ne 0 ]; then
  echo "❌ Erreur lors de l'ajout du domaine. Il est peut-être déjà configuré."
  echo ""
  echo "📋 Domaines actuellement configurés :"
  heroku domains --app $APP_NAME
  exit 1
fi

echo ""
echo "✅ Domaine ajouté sur Heroku !"
echo ""

# Afficher les informations DNS
echo "📋 Étape 2 : Configuration DNS requise"
echo "======================================"
echo ""
echo "Heroku va vous donner un enregistrement DNS à configurer."
echo "Exécutez cette commande pour voir les détails :"
echo ""
echo "  heroku domains --app $APP_NAME"
echo ""

# Afficher les domaines configurés
echo "📋 Domaines configurés sur Heroku :"
heroku domains --app $APP_NAME

echo ""
echo "📋 Étape 3 : Configuration SSL automatique"
echo "=========================================="
echo ""

# Activer SSL automatique
read -p "🔒 Activer SSL automatique (gratuit) ? (o/n): " ENABLE_SSL

if [ "$ENABLE_SSL" = "o" ] || [ "$ENABLE_SSL" = "O" ] || [ "$ENABLE_SSL" = "y" ] || [ "$ENABLE_SSL" = "Y" ]; then
  echo ""
  echo "⚙️  Activation de SSL automatique..."
  heroku certs:auto:enable --app $APP_NAME
  
  if [ $? -eq 0 ]; then
    echo "✅ SSL automatique activé !"
    echo ""
    echo "⏳ Le certificat SSL sera généré automatiquement une fois le DNS configuré."
    echo "   Cela peut prendre quelques minutes à quelques heures."
  else
    echo "⚠️  Erreur lors de l'activation de SSL. Vous pouvez le faire manuellement plus tard avec :"
    echo "   heroku certs:auto:enable --app $APP_NAME"
  fi
else
  echo "⏭️  SSL non activé. Vous pouvez l'activer plus tard avec :"
  echo "   heroku certs:auto:enable --app $APP_NAME"
fi

echo ""
echo "📋 Étape 4 : Instructions pour votre registrar de domaine"
echo "=========================================================="
echo ""
echo "Maintenant, vous devez configurer le DNS chez votre registrar (Namecheap, GoDaddy, etc.)"
echo ""
echo "1. Connectez-vous à votre panneau DNS"
echo "2. Ajoutez un enregistrement CNAME :"
echo ""
echo "   Pour www.tubenplay.com :"
echo "   - Type: CNAME"
echo "   - Host: www"
echo "   - Value: $APP_NAME.herokuapp.com"
echo "   - TTL: 3600 (ou Automatic)"
echo ""
echo "   Pour tubenplay.com (domaine racine) :"
echo "   - Option A: Utilisez un enregistrement ALIAS/ANAME (si disponible)"
echo "   - Option B: Utilisez un enregistrement A avec l'IP fournie par Heroku"
echo "   - Note: Heroku fournira l'IP après l'ajout du domaine"
echo ""
echo "3. Attendez la propagation DNS (peut prendre jusqu'à 48h, généralement quelques minutes)"
echo ""
echo "4. Vérifiez la configuration avec :"
echo "   heroku domains --app $APP_NAME"
echo "   heroku certs --app $APP_NAME"
echo ""
echo "✅ Configuration terminée !"
echo ""

