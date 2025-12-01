#!/bin/bash
# Script pour configurer SSL/HTTPS sur Heroku

APP_NAME="tubenplay-app"

echo "🔒 Configuration SSL sur Heroku"
echo "================================"
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

# Vérifier les domaines configurés
echo "📋 Domaines configurés sur Heroku :"
heroku domains --app $APP_NAME

echo ""
echo ""

# Vérifier le statut SSL actuel
echo "📋 Statut SSL actuel :"
heroku certs --app $APP_NAME

echo ""
echo ""

# Vérifier le type de dyno
echo "📋 Vérification du type de dyno..."
DYNO_TYPE=$(heroku ps --app $APP_NAME | head -2 | tail -1 | awk '{print $2}')

if [[ "$DYNO_TYPE" == "eco" ]] || [[ "$DYNO_TYPE" == "free" ]]; then
    echo "⚠️  Attention: Vous êtes sur un dyno gratuit/eco"
    echo "   ACM nécessite un dyno payant (Hobby: 7$/mois)"
    echo ""
    read -p "Voulez-vous continuer quand même ? (o/n): " CONTINUE
    
    if [[ "$CONTINUE" != "o" ]] && [[ "$CONTINUE" != "O" ]] && [[ "$CONTINUE" != "y" ]] && [[ "$CONTINUE" != "Y" ]]; then
        echo "❌ Configuration annulée"
        exit 1
    fi
fi

echo ""
echo ""

# Activer ACM
echo "⚙️  Activation d'Automated Certificate Management (ACM)..."
echo ""

heroku certs:auto:enable --app $APP_NAME

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ACM activé avec succès !"
    echo ""
    echo "⏳ Le certificat SSL sera généré automatiquement dans les prochaines minutes."
    echo "   Cela peut prendre de 5 à 30 minutes après la propagation DNS."
    echo ""
    echo "📋 Pour vérifier le statut :"
    echo "   heroku certs --app $APP_NAME"
    echo ""
    echo "🔍 Pour tester HTTPS :"
    echo "   curl -I https://www.tubenplay.com"
    echo "   ou"
    echo "   heroku open --app $APP_NAME"
    echo ""
else
    echo ""
    echo "❌ Erreur lors de l'activation d'ACM"
    echo ""
    echo "🔍 Causes possibles :"
    echo "   - DNS non configuré ou non propagé"
    echo "   - Dyno gratuit (nécessite un dyno payant)"
    echo "   - Domaine non vérifié"
    echo ""
    echo "📋 Vérifiez :"
    echo "   1. DNS configuré : heroku domains --app $APP_NAME"
    echo "   2. Propagation DNS : dig www.tubenplay.com CNAME"
    echo "   3. Type de dyno : heroku ps --app $APP_NAME"
    exit 1
fi

echo ""
echo "✅ Configuration SSL terminée !"
echo ""

