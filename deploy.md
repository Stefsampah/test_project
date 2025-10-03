# 🚀 Guide de Déploiement Heroku

## 📋 **État Prêt pour Production** ✅

### **Tests Automatisés**
- ✅ Tous les tests automatisés corrigés et fonctionnels
- ✅ Erreurs identifiées et résolues
- ✅ Coverage complète des fonctionnalités clés

### **Configuration Production**
- ✅ Base de donnée PostgreSQL configurée pour Heroku
- ✅ Variables d'environnement sécurisées
- ✅ Configuration SSL activée
- ✅ Assets précompilés

### **Intégration Stripe**
- ✅ Paiements in-app fonctionnels
- ✅ Abonnements VIP
- ✅ Gestion des erreurs Stripe
- ✅ Mode simulation pour tests

## 🔧 **Étapes de Déploiement**

### **1. Prérequis**
```bash
# Installer Heroku CLI
npm install -g heroku
# Ou via Homebrew
brew install heroku/brew/heroku
```

### **2. Configuration Initiale**
```bash
# Cloner le projet
git clone <votre-repo>
cd test_project

# Se connecter à Heroku
heroku login

# Créer l'app Heroku
heroku create votre-app-name
```

### **3. Variables d'Environnement**
```bash
# Configurer les variables d'environnement
heroku config:set SECRET_KEY_BASE=$(rails secret)
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_live_votre_clé_public
heroku config:set STRIPE_SECRET_KEY=sk_live_votre_clé_secrète
heroku config:set RAILS_ENV=production
```

### **4. Base de Données**
```bash
# Ajouter PostgreSQL
heroku addons:create heroku-postgresql:mini

# Migrer la base de données
heroku run rails db:migrate

# Seeder les données initiales (optionnel)
heroku run rails db:seed
```

### **5. Déploiement**
```bash
# Déployer
git push heroku main

# Vérifier les logs
heroku logs --tail
```

## ⚡ **Commandes Utiles Post-Déploiement**

### **Monitoring**
```bash
# Voir les logs en temps réel
heroku logs --tail

# Statut de l'app
heroku ps

# Informations sur l'app
heroku info
```

### **Base de Données**
```bash
# Accès à la console Rails en production
heroku run rails console

# Backup de la base de données
heroku pg:backups:capture

# Restaurer un backup
heroku pg:backups:restore
```

### **Maintenance**
```bash
# Redémarrer l'app
heroku restart

# Mettre à jour les assets
heroku run rails assets:precompile
```

## 🔒 **Configuration Stripe**

### **Environnement de Test**
```bash
# Clés Stripe Test
STRIPE_PUBLISHABLE_KEY=pk_test_51...
STRIPE_SECRET_KEY=sk_test_51...
```

### **Environnement de Production**
```bash
# Clés Stripe Live
STRIPE_PUBLISHABLE_KEY=pk_live_51...
STRIPE_SECRET_KEY=sk_live_51...
```

### **Webhooks Stripe**
- **URL**: `https://votre-app.herokuapp.com/stripe/webhooks`
- **Événements**: `checkout.session.completed`, `payment_intent.succeeded`

## 🎯 **Fonctionnalités Testées**

### **✅ Système de Jeu**
- Création de parties
- Système de swipe like/dislike
- Calcul automatique des scores
- Récompenses et badges

### **✅ Système de Paiement**
- Achat de points in-app
- Abonnements VIP
- Validation des paiements Stripe
- Gestion des erreurs

### **✅ Système de Récompenses**
- Badges automatiques
- Déblocage de playlists premium
- Collection Arc-en-ciel
- Notifications utilisateur

## 🔧 **Dépannage**

### **Problèmes Courants**
1. **Base de données**: Vérifier les migrations
2. **Assets**: Recompiler en cas d'erreur
3. **Stripe**: Vérifier les clés d'API
4. **SSL**: Vérifier la configuration HTTPS

### **Support**
- Logs Heroku: `heroku logs --tail`
- Console Rails: `heroku run rails console`
- Support Heroku: https://help.heroku.com

## 🚀 **Lien Production**

Une fois déployé, votre application sera accessible à :
**https://votre-app-name.herokuapp.com**

## ✅ **Checklist Final**

- [ ] Tests automatisés passés
- [ ] Variables d'environnement configurées
- [ ] Stripe configuré (test ou live)
- [ ] Base de données migrée
- [ ] Assets compilés
- [ ] SSL activé
- [ ] Logs vérifiés

**🎉 Votre application est prête pour la production !**
