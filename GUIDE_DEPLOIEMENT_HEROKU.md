# 🚀 Guide de Déploiement Heroku - Tube'NPlay

## 📋 Étape 1 : Commit et Préparation

```bash
# Vérifier que tout est commité
git status

# Si des fichiers ne sont pas commités, les ajouter
git add -A
git commit -m "feat: Migration PayPal, onglets Boutique/Ma boutique et améliorations UX"
```

## 🔐 Étape 2 : Se connecter à Heroku

```bash
# Se connecter à Heroku (si pas déjà connecté)
heroku login

# Vérifier que vous êtes connecté
heroku auth:whoami
```

## 🏗️ Étape 3 : Créer ou Vérifier l'App Heroku

```bash
# Si l'app n'existe pas encore
heroku create tubenplay

# Si l'app existe déjà, ajouter le remote
heroku git:remote -a tubenplay
```

## 📦 Étape 4 : Déployer sur Heroku

```bash
# Déployer le code
git push heroku master

# OU si vous êtes sur la branche main
git push heroku master:main
```

## 🗄️ Étape 5 : Configurer la Base de Données

```bash
# Ajouter PostgreSQL (si pas déjà fait)
heroku addons:create heroku-postgresql:mini

# Migrer la base de données
heroku run rails db:migrate

# (Optionnel) Seeder les données initiales
heroku run rails db:seed
```

## 🔑 Étape 6 : Configurer les Variables d'Environnement

```bash
# Générer une SECRET_KEY_BASE
heroku config:set SECRET_KEY_BASE=$(rails secret)

# Configurer PayPal (remplacer par vos vraies clés)
heroku config:set PAYPAL_CLIENT_ID=votre_client_id_paypal
heroku config:set PAYPAL_CLIENT_SECRET=votre_client_secret_paypal
heroku config:set PAYPAL_MODE=sandbox

# Vérifier les variables configurées
heroku config
```

## 🌐 Étape 7 : Configurer le Domaine www.tubenplay.com

### 7.1. Ajouter le domaine sur Heroku

```bash
# Ajouter le domaine www.tubenplay.com
heroku domains:add www.tubenplay.com -a tubenplay
```

### 7.2. Configurer DNS chez votre hébergeur de domaine

Heroku vous donnera un enregistrement DNS CNAME à configurer :

```bash
# Voir les domaines configurés
heroku domains -a tubenplay
```

**Dans votre panneau DNS (chez votre registrar de domaine) :**

1. Créez un enregistrement **CNAME** :
   - **Nom/Host** : `www`
   - **Valeur/Point vers** : `tubenplay.herokuapp.com` (ou ce que Heroku vous indique)
   - **TTL** : 3600 (ou défaut)

2. (Optionnel) Pour le domaine racine `tubenplay.com` :
   - Créez un enregistrement **ALIAS** ou **ANAME** pointant vers `tubenplay.herokuapp.com`
   - OU créez un enregistrement **A** pointant vers l'IP fournie par Heroku

### 7.3. Vérifier la configuration SSL

```bash
# Activer SSL automatique (gratuit avec Heroku)
heroku certs:auto:enable -a tubenplay

# Vérifier le statut SSL
heroku certs -a tubenplay
```

## ✅ Étape 8 : Vérifier le Déploiement

```bash
# Voir les logs en temps réel
heroku logs --tail -a tubenplay

# Ouvrir l'app dans le navigateur
heroku open -a tubenplay

# Vérifier le statut
heroku ps -a tubenplay
```

## 🔍 Étape 9 : Tests Post-Déploiement

1. **Tester l'application** : Visiter `https://www.tubenplay.com`
2. **Tester les paiements PayPal** : Vérifier que PayPal Sandbox fonctionne
3. **Tester les onglets** : Boutique / Ma boutique
4. **Vérifier les logs** : `heroku logs --tail -a tubenplay`

## 🛠️ Commandes Utiles

```bash
# Console Rails en production
heroku run rails console -a tubenplay

# Voir les variables d'environnement
heroku config -a tubenplay

# Modifier une variable
heroku config:set VARIABLE=valeur -a tubenplay

# Redémarrer l'app
heroku restart -a tubenplay

# Voir les domaines
heroku domains -a tubenplay

# Supprimer un domaine
heroku domains:remove www.tubenplay.com -a tubenplay
```

## ⚠️ Notes Importantes

1. **PayPal** : N'oubliez pas de passer en mode `live` et de configurer les vraies clés PayPal en production
2. **SECRET_KEY_BASE** : Ne partagez jamais cette clé
3. **Base de données** : Faites des backups réguliers avec `heroku pg:backups:capture`
4. **SSL** : Heroku gère automatiquement les certificats SSL pour les domaines personnalisés

## 🆘 En cas de Problème

```bash
# Voir les logs d'erreur
heroku logs --tail -a tubenplay

# Vérifier les dynos
heroku ps -a tubenplay

# Redémarrer l'app
heroku restart -a tubenplay
```

