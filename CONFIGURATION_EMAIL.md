# 📧 Configuration Email - Guide Complet

## ✅ Modifications Effectuées

### 1. Validation Email Renforcée (`app/models/user.rb`)

**Ajouts :**
- ✅ Validation de format email stricte (RFC 5322)
- ✅ Validation de longueur (max 255 caractères)
- ✅ Validation de domaine (rejet des domaines invalides)
- ✅ Normalisation automatique (lowercase + trim)
- ✅ Vérification de l'unicité (case-insensitive)

**Domaines invalides rejetés :**
- `example.com`
- `test.com`
- `invalid.com`
- `localhost`
- `domain.com`

### 2. ApplicationMailer (`app/mailers/application_mailer.rb`)

**Configuration flexible :**
- Priorité 1: Variable d'environnement `MAILER_FROM_ADDRESS`
- Priorité 2: Credentials Rails `mailer.from_address`
- Priorité 3: Valeur par défaut `noreply@[MAILER_DOMAIN]`

### 3. Devise Mailer (`config/initializers/devise.rb`)

**Configuration flexible :**
- Priorité 1: Variable d'environnement `DEVISE_MAILER_SENDER`
- Priorité 2: Credentials Rails `devise.mailer_sender`
- Priorité 3: Valeur par défaut `noreply@[MAILER_DOMAIN]`

### 4. Configuration Production (`config/environments/production.rb`)

**Améliorations :**
- ✅ Host configurable via `MAILER_DOMAIN` ou `HOST`
- ✅ Configuration SMTP complète activée
- ✅ Support des variables d'environnement et credentials Rails
- ✅ Protocol HTTPS forcé pour les liens

---

## 🔧 Configuration Heroku

### Variables d'Environnement Requises

#### Variables Obligatoires

```bash
# Domaine de l'application (pour les liens dans les emails)
heroku config:set MAILER_DOMAIN=votre-domaine.com

# Configuration SMTP
heroku config:set SMTP_ADDRESS=smtp.gmail.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=votre-email@gmail.com
heroku config:set SMTP_PASSWORD=votre-mot-de-passe-app
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

#### Variables Optionnelles (si vous voulez surcharger les valeurs par défaut)

```bash
# Adresse expéditeur personnalisée
heroku config:set MAILER_FROM_ADDRESS=noreply@votre-domaine.com

# Expéditeur Devise personnalisé
heroku config:set DEVISE_MAILER_SENDER=noreply@votre-domaine.com

# Domaine SMTP (si différent de MAILER_DOMAIN)
heroku config:set SMTP_DOMAIN=votre-domaine.com
```

### Alternative : Utiliser Rails Credentials

Si vous préférez utiliser les credentials Rails au lieu des variables d'environnement :

```bash
# Éditer les credentials
EDITOR="code --wait" rails credentials:edit
```

Ajouter dans le fichier :

```yaml
mailer:
  from_address: noreply@votre-domaine.com

devise:
  mailer_sender: noreply@votre-domaine.com

smtp:
  address: smtp.gmail.com
  user_name: votre-email@gmail.com
  password: votre-mot-de-passe-app
```

---

## 📋 Exemples de Configuration par Fournisseur

### Gmail

```bash
heroku config:set SMTP_ADDRESS=smtp.gmail.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=votre-email@gmail.com
heroku config:set SMTP_PASSWORD=votre-mot-de-passe-application
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

**Note:** Pour Gmail, vous devez :
1. Activer l'authentification à deux facteurs
2. Générer un "Mot de passe d'application" dans les paramètres Google
3. Utiliser ce mot de passe dans `SMTP_PASSWORD`

### SendGrid

```bash
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=apikey
heroku config:set SMTP_PASSWORD=votre-api-key-sendgrid
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

### Mailgun

```bash
heroku config:set SMTP_ADDRESS=smtp.mailgun.org
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=postmaster@votre-domaine.mailgun.org
heroku config:set SMTP_PASSWORD=votre-mot-de-passe-mailgun
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

### Amazon SES

```bash
heroku config:set SMTP_ADDRESS=email-smtp.region.amazonaws.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=votre-access-key-id
heroku config:set SMTP_PASSWORD=votre-secret-access-key
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

---

## 🧪 Tests

### Tester en Développement

```ruby
# Dans rails console
user = User.find_by(email: 'test@example.com')
UserMailer.welcome_email(user).deliver_now
```

### Tester en Production (Heroku)

```bash
# Accéder à la console Heroku
heroku run rails console

# Tester l'envoi d'email
user = User.first
UserMailer.welcome_email(user).deliver_now
```

### Vérifier la Configuration

```bash
# Voir toutes les variables d'environnement
heroku config

# Voir les logs en temps réel
heroku logs --tail
```

---

## 🔒 Sécurité

### Bonnes Pratiques

1. ✅ **Ne jamais commiter les mots de passe** dans le code
2. ✅ **Utiliser des variables d'environnement** ou Rails credentials
3. ✅ **Utiliser des mots de passe d'application** (Gmail) plutôt que le mot de passe principal
4. ✅ **Activer l'authentification à deux facteurs** sur le compte email
5. ✅ **Utiliser HTTPS** pour tous les liens dans les emails (déjà configuré)

### Vérification

- ✅ Les emails sont normalisés (lowercase, trim)
- ✅ Les domaines invalides sont rejetés
- ✅ La validation est stricte (format RFC 5322)
- ✅ Les erreurs d'envoi sont loggées en production

---

## 🐛 Dépannage

### Les emails ne partent pas

1. Vérifier les variables d'environnement : `heroku config`
2. Vérifier les logs : `heroku logs --tail`
3. Tester la connexion SMTP dans la console Rails
4. Vérifier que `raise_delivery_errors` est à `true` en production

### Erreur "Authentication failed"

- Vérifier les identifiants SMTP
- Pour Gmail, utiliser un mot de passe d'application
- Vérifier que le compte n'est pas verrouillé

### Erreur "Domain not found"

- Vérifier que `MAILER_DOMAIN` est correctement configuré
- Vérifier que le domaine DNS est correctement configuré

---

## 📝 Checklist de Déploiement

- [ ] Variables d'environnement configurées sur Heroku
- [ ] `MAILER_DOMAIN` configuré avec le bon domaine
- [ ] Configuration SMTP testée
- [ ] Test d'envoi d'email réussi
- [ ] DNS configuré pour le domaine personnalisé
- [ ] SSL/HTTPS activé sur Heroku
- [ ] Logs vérifiés pour les erreurs

---

## 🎯 Prochaines Étapes

1. ✅ Configuration email renforcée - **TERMINÉ**
2. ⏳ Configurer le DNS personnalisé sur Heroku
3. ⏳ Déployer sur Heroku
4. ⏳ Tester l'envoi d'emails en production

