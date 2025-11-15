# 📊 État des Lieux - Test Project

**Date:** $(date)
**Branche:** `ui-experiments`
**Dernier commit:** `b3863b8` - Uniformisation de la charte graphique en violet

---

## 🔄 État Git

### Modifications non commitées
- ✅ `app/controllers/games_controller.rb` - Gestion des verrouillages SQLite avec retry
- 📝 `TODO_SQLITE_LOCK.md` - Documentation du problème SQLite (non tracké)

### Branche actuelle
- **Branche:** `ui-experiments`
- **Statut:** Modifications en cours

---

## 📧 Configuration Email - À RENFORCER

### État actuel

#### 1. ApplicationMailer (`app/mailers/application_mailer.rb`)
```ruby
default from: "from@example.com"  # ❌ À CHANGER
```

#### 2. Devise (`config/initializers/devise.rb`)
```ruby
config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'  # ❌ À CHANGER
```

#### 3. Production (`config/environments/production.rb`)
```ruby
config.action_mailer.default_url_options = { host: "example.com" }  # ❌ À CHANGER
# Configuration SMTP commentée - ❌ À ACTIVER
```

#### 4. Validation Email
- **Modèle User:** Utilise Devise `:validatable` qui inclut une validation email basique
- **Regex Devise:** `/\A[^@\s]+@[^@\s]+\z/` - Très permissive (uniquement vérifie la présence d'un @)
- **Pas de validation personnalisée** dans le modèle User

### Actions à effectuer

1. ✅ **Renforcer la validation email** dans le modèle User
   - Ajouter une validation plus stricte (format RFC 5322)
   - Vérifier les domaines invalides courants
   - Normaliser les emails (lowercase, trim)

2. ✅ **Configurer les mailers**
   - Changer `from` dans ApplicationMailer
   - Changer `mailer_sender` dans Devise
   - Configurer le host de production

3. ✅ **Configurer SMTP pour la production**
   - Activer la configuration SMTP dans `production.rb`
   - Utiliser les credentials Rails pour les secrets

---

## 🚀 Configuration Heroku

### État actuel

#### Fichiers de configuration
- ✅ `app.json` - Configuration Heroku présente
- ✅ `deploy.md` - Documentation de déploiement complète

#### Configuration actuelle (`app.json`)
```json
{
  "name": "test_project_rails_app",
  "addons": [{"plan": "heroku-postgresql:mini"}],
  "stack": "heroku-22"
}
```

### Actions à effectuer

1. ✅ **Configurer le DNS personnalisé**
   - Ajouter le domaine dans Heroku
   - Configurer les enregistrements DNS
   - Mettre à jour `config/environments/production.rb` avec le bon host

2. ✅ **Variables d'environnement Heroku**
   - `SECRET_KEY_BASE`
   - `STRIPE_PUBLISHABLE_KEY`
   - `STRIPE_SECRET_KEY`
   - Variables SMTP (si nécessaire)

3. ✅ **Déploiement**
   - Migrations de base de données
   - Précompilation des assets
   - Tests de fonctionnement

---

## 📋 Checklist des Actions

### Phase 1: Renforcement des Emails
- [ ] Ajouter validation email stricte dans `app/models/user.rb`
- [ ] Mettre à jour `app/mailers/application_mailer.rb` avec le bon `from`
- [ ] Mettre à jour `config/initializers/devise.rb` avec le bon `mailer_sender`
- [ ] Configurer SMTP dans `config/environments/production.rb`
- [ ] Tester l'envoi d'emails en développement

### Phase 2: Configuration Heroku
- [ ] Vérifier/créer l'app Heroku
- [ ] Configurer le DNS personnalisé
- [ ] Mettre à jour `production.rb` avec le bon host
- [ ] Configurer les variables d'environnement
- [ ] Tester la configuration SMTP sur Heroku

### Phase 3: Déploiement
- [ ] Commiter les modifications en cours
- [ ] Pousser sur Heroku
- [ ] Exécuter les migrations
- [ ] Vérifier les logs
- [ ] Tester l'application en production

---

## 🔍 Points d'Attention

### SQLite en développement
- ⚠️ Problème de verrouillage SQLite documenté dans `TODO_SQLITE_LOCK.md`
- ✅ Solution temporaire avec retry implémentée dans `games_controller.rb`
- 💡 À considérer: Migration vers PostgreSQL même en développement

### Emails
- ⚠️ Configuration email actuelle non fonctionnelle pour la production
- ⚠️ Pas de validation email renforcée
- ⚠️ Host de production à configurer

### Heroku
- ⚠️ DNS personnalisé non configuré
- ⚠️ Variables d'environnement à vérifier

---

## 📝 Prochaines Étapes Recommandées

1. **Immédiat:** Renforcer la validation email
2. **Immédiat:** Configurer les mailers avec les bonnes adresses
3. **Avant déploiement:** Configurer le DNS Heroku
4. **Déploiement:** Tester l'envoi d'emails en production

