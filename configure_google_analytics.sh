#!/bin/bash
# Script pour configurer Google Analytics 4 sur Heroku

APP_NAME="tubenplay-app"

echo "📊 Configuration Google Analytics 4"
echo "===================================="
echo ""

# Vérifier que Heroku CLI est installé
if ! command -v heroku &> /dev/null; then
    echo "❌ Erreur: Heroku CLI n'est pas installé"
    echo "   Installez-le avec: https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Vérifier la connexion Heroku
echo "📋 Vérification de la connexion Heroku..."
if ! heroku auth:whoami &> /dev/null; then
    echo "❌ Erreur: Vous n'êtes pas connecté à Heroku"
    echo "   Connectez-vous avec: heroku login"
    exit 1
fi

echo "✅ Connecté à Heroku"
echo ""

# Demander l'ID de mesure
echo "📋 Pour obtenir votre ID de mesure Google Analytics :"
echo "   1. Allez sur https://analytics.google.com/"
echo "   2. Créez une propriété pour www.tubenplay.com"
echo "   3. Copiez l'ID de mesure (format: G-XXXXXXXXXX)"
echo ""

read -p "🔑 Entrez votre ID de mesure Google Analytics (G-XXXXXXXXXX): " GA_ID

if [ -z "$GA_ID" ]; then
    echo "❌ Erreur: L'ID de mesure ne peut pas être vide"
    exit 1
fi

# Vérifier le format de l'ID
if [[ ! "$GA_ID" =~ ^G-[A-Z0-9]{10}$ ]]; then
    echo "⚠️  Attention: L'ID ne correspond pas au format attendu (G-XXXXXXXXXX)"
    read -p "Continuer quand même ? (o/n): " CONTINUE
    
    if [[ "$CONTINUE" != "o" ]] && [[ "$CONTINUE" != "O" ]] && [[ "$CONTINUE" != "y" ]] && [[ "$CONTINUE" != "Y" ]]; then
        echo "❌ Configuration annulée"
        exit 1
    fi
fi

echo ""
echo "⚙️  Configuration de Google Analytics sur Heroku..."
echo ""

# Configurer la variable d'environnement
heroku config:set GA_MEASUREMENT_ID="$GA_ID" --app $APP_NAME

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Google Analytics configuré avec succès !"
    echo ""
    echo "📊 ID de mesure configuré : $GA_ID"
    echo ""
    echo "🔄 Redémarrage de l'application..."
    heroku restart --app $APP_NAME
    
    echo ""
    echo "✅ Configuration terminée !"
    echo ""
    echo "📋 Prochaines étapes :"
    echo "   1. Attendez quelques minutes pour que les données commencent à apparaître"
    echo "   2. Allez sur https://analytics.google.com/ pour voir vos statistiques"
    echo "   3. Les données peuvent prendre jusqu'à 24h pour être complètes"
    echo ""
    echo "🔍 Pour vérifier la configuration :"
    echo "   heroku config:get GA_MEASUREMENT_ID --app $APP_NAME"
    echo ""
else
    echo ""
    echo "❌ Erreur lors de la configuration"
    exit 1
fi

