# 🔄 Workflow de Développement avec Heroku

## 📋 **Processus de Mise à Jour**

### **1. 🔧 Modifications Locales**
```bash
# Effectuer vos modifications dans le code
# Tester localement
rails test                    # Tests automatisés
rails server -p 3000        # Serveur local pour tests
```

### **2. 📤 Déploiement sur Heroku**

#### **Méthode Simple (Recommandée)**
```bash
# Ajouter vos changements
git add .
git commit -m "Description de vos modifications"

# Déployer directement sur Heroku
git push heroku main
```

#### **Méthode avec Branche (Préférée pour la production)**
```bash
# Créer une branche pour vos modifications
git checkout -b feature/nouvelle-fonctionnalite
git add .
git commit -m "Add nouvelle fonctionnalité"

# Pusher la branche sur Heroku
git push heroku feature/nouvelle-fonctionnalite:main
```

### **3. 🔄 Actions Automatiques**

Heroku exécute automatiquement lors du déploiement :

#### **📦 Installations**
```bash
# Détection automatique de Ruby/Node.js
# Installation des gems (Gemfile)
# Installation des packages npm (package.json)
```

#### **🏗️ Build Process**
```bash
# Compilation des assets CSS/JS
# Précompilation Rails assets:precompile
# Optimisation des fichiers
```

#### **🔄 Migration de Base de Données**
```bash
# Si vous avez de nouvelles migrations
heroku run rails db:migrate
```

## 🎯 **Différents Types de Modifications**

### **🆕 Nouvelles Fonctionnalités**
```bash
# 1. Ajouter le code
# 2. Tests
# 3. Commit
git add .
git commit -m "Ajout fonctionnalité XYZ"
git push heroku main

# 4. Migrations si nécessaire
heroku run rails db:migrate
```

### **🐛 Corrections de Bugs**
```bash
# 1. Corriger le bug
# 2. Tests pour vérifier
# 3. Déploiement rapide
git add .
git commit -m "Fix: correction du bug XYZ"
git push heroku main
```

### **⚡ Modifications de Configuration**

#### **Variables d'Environnement**
```bash
# AJOUTER une nouvelle variable
heroku config:set NOUVELLE_VAR=valeur

# MODIFIER une variable existante
heroku config:set STRIPE_SECRET_KEY=nouvelle_cle

# VOIR toutes les variables
heroku config
```

#### **Configuration Gemfile**
```bash
# Ajouter/modifier des gems dans Gemfile
git add Gemfile Gemfile.l_lock
git commit -m "Update gems"
git push heroku main
```

### **📊 Modifications de Base de Données**

#### **Nouvelles Migrations**
```bash
# Créer la migration localement
rails generate migration AddNouvelleColonne table colonne:string

# Tester localement
rails db:migrate
rails test

# Déployer
git add .
git commit -m "Add migration: nouvelle colonne"
git push heroku main

# Appliquer sur Heroku
heroku run rails db:migrate
```

#### **Seeds et Données Initiales**
```bash
# Ajouter des données de test
heroku run rails db:seed

# Ou exécuter du code spécifique
heroku run rails console
# Puis dans la console Rails :
# User.create!(email: "test@example.com", ...)
```

## 🛠️ **Outils de Debugging**

### **📋 Vérification Post-Déploiement**
```bash
# Voir les logs en temps réel
heroku logs --tail

# Statut de l'application
heroku ps

# Informations générales
heroku info
```

### **🔧 Debug Direct en Production**
```bash
# Console Rails en production
heroku run rails console

# Accès à la base de données
heroku pg:psql

# Exécuter une tâche spécifique
heroku run rails tasks:task_name
```

## 🚨 **Cas Spéciaux**

### **🔙 Rollback Rapide**
```bash
# En cas de problème, revenir en arrière
heroku releases
heroku rollback v123

# Ou revenir à un commit spécifique
git revert HEAD
git push heroku main
```

### **🔄 Maintenance Programmée**
```bash
# Mettre l'app en mode maintenance
heroku maintenance:on

# Appliquer les changements
# ... vos modifications ...

# Remettre l'app en ligne
heroku maintenance:off
```

### **📈 Redimensionnement**
```bash
# Augmenter les ressources si nécessaire
heroku ps:scale web=2  # Doubler les dynos
heroku ps:scale web=1  # Retour au minimum
```

## 💰 **Coûts et Limites**

### **🆓 Plan Gratuit Heroku**
- ⏰ App s'endort après 30min d'inactivité
- 📊 Limité à 1000h/mois
- 🗄️ Base PostgreSQL limitée (10000 lignes)

### **💴 Plan Payant**
- 🚀 App toujours active
- 📊 Ressources illimitées
- 🗄️ Base PostgreSQL évolutive

## 📱 **Bonnes Pratiques**

### **✅ Avant Chaque Déploiement**
```bash
# 1. Tests locaux
rails test

# 2. Vérification assets
rails assets:precompile

# 3. Commit propre
git add .
git commit -m "Descriptive commit message"

# 4. Déploiement
git push heroku main
```

### **🔍 Après Chaque Déploiement**
```bash
# 1. Vérifier les logs
heroku logs --tail -n 100

# 2. Tester la fonctionnalité
# Visiter votre app et tester

# 3. Vérifier Stripe (si applicable)
# Tester un paiement test
```

## 🎯 **Commande de Déploiement Rapide**

Pour les modifications courantes, cette séquence suffit :

```bash
# Déploiement standard
git add .
git commit -m "Update: description courte"
git push heroku main

# Vérification
heroku logs --tail
```

## 🚀 **Exemple Concret**

Supposons que vous voulez ajouter un nouveau pack de points :

### **1. Modification Locale**
```bash
# Modifier le code
vim app/controllers/store_controller.rb
# Ajouter le nouveau pack (ex: pack 5000 points)

# Tester
rails test
```

### **2. Déploiement**
```bash
git add .
git commit -m "Add pack 5000 points in store"
git push heroku main
```

### **3. Vérification**
```bash
# Suivre les logs
heroku logs --tail

# Tester en production
# Aller sur votre-app.herokuapp.com/store
# Vérifier que le nouveau pack apparaît
```

**🎉 C'est tout ! Vos modifications sont en production en quelques minutes !**

## ⚡ **Optimisations**

### **🚀 Déploiement Ultra-Rapide**
```bash
# Pour les petits changements, déploiement en continu
git push heroku HEAD:main
```

### **🔄 Déploiement Automatique**
Configurez GitHub Actions pour déployer automatiquement :
```yaml
# .github/workflows/deploy.yml
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Heroku
        uses: akhileshns/heroku-deploy@v3.12.12
        with:
          heroku_api_key: ${{secrets.HEROKU_API_KEY}}
          heroku_app_name: "votre-app-name"
          heroku_email: "votre-email@exemple.com"
```
