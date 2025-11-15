# 📧 Guide Namecheap : Configuration des Emails pour l'Application

## ⚠️ Important : Différence entre Email Forwarding et Private Email

### Email Forwarding (Gratuit - ❌ Ne fonctionne PAS pour envoyer)
- ✅ Permet de **recevoir** des emails
- ✅ Permet de **rediriger** vers d'autres adresses
- ❌ **NE PERMET PAS d'envoyer** des emails depuis l'application
- ❌ Pas de serveur SMTP pour l'envoi

### Private Email (Payant - ✅ Fonctionne pour tout)
- ✅ Permet de **recevoir** des emails
- ✅ Permet d'**envoyer** des emails (SMTP)
- ✅ Compte email complet avec boîte de réception
- ✅ Serveur SMTP inclus

## 🎯 Solution : Utiliser Namecheap Private Email

Pour que votre application puisse **envoyer** des emails aux joueurs, vous devez utiliser **Private Email** de Namecheap.

---

## 📋 Étape 1 : Activer Private Email sur Namecheap

### 1.1 Se connecter à Namecheap

1. Allez sur https://www.namecheap.com
2. Cliquez sur **"Sign In"** (en haut à droite)
3. Connectez-vous avec vos identifiants

### 1.2 Activer Private Email pour votre domaine

1. Dans votre tableau de bord, cliquez sur **"Domain List"** (menu de gauche)
2. Trouvez votre domaine **`tubenplay.com`**
3. Cliquez sur **"Manage"** à côté du domaine

### 1.3 Acheter/Activer Private Email

1. Cherchez la section **"Email"** ou **"Private Email"**
2. Cliquez sur **"Get Private Email"** ou **"Activate"**
3. Choisissez le plan (généralement le plan de base suffit)
4. Suivez les instructions pour activer le service

**Prix approximatif :** ~$1-2 USD/mois par boîte email

---

## 📋 Étape 2 : Créer les Adresses Email

### 2.1 Accéder à la Gestion des Emails

1. Dans la page de gestion de votre domaine
2. Allez dans l'onglet **"Email"** ou **"Private Email"**
3. Cliquez sur **"Create"** ou **"Add Email Account"**

### 2.2 Créer les 5 Adresses Email

Créez ces adresses une par une :

#### 1. `noreply@tubenplay.com` (OBLIGATOIRE)
- **Nom d'utilisateur** : `noreply`
- **Mot de passe** : Créez un mot de passe fort (notez-le !)
- **Quota** : 1 GB suffit généralement

#### 2. `admin@tubenplay.com`
- **Nom d'utilisateur** : `admin`
- **Mot de passe** : Créez un mot de passe
- **Quota** : 1 GB

#### 3. `user@tubenplay.com` (ou `jordan@tubenplay.com`)
- **Nom d'utilisateur** : `user` (ou `jordan`)
- **Mot de passe** : Créez un mot de passe
- **Quota** : 1 GB

#### 4. `driss@tubenplay.com`
- **Nom d'utilisateur** : `driss`
- **Mot de passe** : Créez un mot de passe
- **Quota** : 1 GB

#### 5. `ja@tubenplay.com`
- **Nom d'utilisateur** : `ja`
- **Mot de passe** : Créez un mot de passe
- **Quota** : 1 GB

### 2.3 Noter les Informations

**⚠️ IMPORTANT :** Notez le mot de passe de `noreply@tubenplay.com` - vous en aurez besoin pour configurer SMTP !

---

## 📋 Étape 3 : Paramètres SMTP de Namecheap Private Email

### Informations SMTP pour Heroku

Une fois les adresses créées, utilisez ces paramètres :

```bash
# Configuration SMTP Namecheap Private Email
heroku config:set SMTP_ADDRESS=mail.privateemail.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=noreply@tubenplay.com
heroku config:set SMTP_PASSWORD=votre-mot-de-passe-noreply
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

### Détails des Paramètres

- **SMTP Server** : `mail.privateemail.com`
- **Port** : `587` (TLS) ou `465` (SSL)
- **Username** : L'adresse email complète (ex: `noreply@tubenplay.com`)
- **Password** : Le mot de passe de l'adresse email
- **Encryption** : TLS (port 587) ou SSL (port 465)

---

## 📋 Étape 4 : Configuration Complète sur Heroku

### 4.1 Configuration de Base

```bash
# Domaine de l'application
heroku config:set MAILER_DOMAIN=tubenplay.com

# Adresse expéditeur
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com
```

### 4.2 Configuration SMTP

```bash
# Serveur SMTP Namecheap
heroku config:set SMTP_ADDRESS=mail.privateemail.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=noreply@tubenplay.com
heroku config:set SMTP_PASSWORD=votre-mot-de-passe-noreply
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

### 4.3 Vérifier la Configuration

```bash
heroku config | grep MAILER
heroku config | grep SMTP
```

---

## 📋 Étape 5 : Mettre à Jour les Emails dans la Base de Données

### En Développement Local

1. Ouvrir la console Rails :
```bash
rails console
```

2. Exécuter le script :
```ruby
load 'mettre_a_jour_emails_utilisateurs.rb'
```

3. Vérifier :
```ruby
User.all.each { |u| puts "#{u.username}: #{u.email}" }
```

### Sur Heroku (après déploiement)

```bash
heroku run rails console
```

Puis :
```ruby
load 'mettre_a_jour_emails_utilisateurs.rb'
```

---

## 🔍 Alternative : Utiliser un Service SMTP Externe (Gratuit)

Si vous ne voulez pas payer pour Private Email, vous pouvez utiliser un service SMTP gratuit :

### Option A : SendGrid (Gratuit jusqu'à 100 emails/jour)

1. Créer un compte sur https://sendgrid.com
2. Obtenir une clé API
3. Configurer sur Heroku :

```bash
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=apikey
heroku config:set SMTP_PASSWORD=votre-api-key-sendgrid
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

### Option B : Mailgun (Gratuit jusqu'à 5000 emails/mois)

1. Créer un compte sur https://www.mailgun.com
2. Obtenir les identifiants SMTP
3. Configurer sur Heroku (voir documentation Mailgun)

---

## ✅ Checklist Complète

### Sur Namecheap
- [ ] Activer Private Email pour `tubenplay.com`
- [ ] Créer `noreply@tubenplay.com`
- [ ] Créer `admin@tubenplay.com`
- [ ] Créer `user@tubenplay.com` (ou `jordan@tubenplay.com`)
- [ ] Créer `driss@tubenplay.com`
- [ ] Créer `ja@tubenplay.com`
- [ ] Noter le mot de passe de `noreply@tubenplay.com`

### En Développement Local
- [ ] Mettre à jour les emails dans la base de données
- [ ] Vérifier que les emails sont bien mis à jour

### Sur Heroku
- [ ] Configurer `MAILER_DOMAIN=tubenplay.com`
- [ ] Configurer `MAILER_FROM_ADDRESS=noreply@tubenplay.com`
- [ ] Configurer `DEVISE_MAILER_SENDER=noreply@tubenplay.com`
- [ ] Configurer `SMTP_ADDRESS=mail.privateemail.com`
- [ ] Configurer `SMTP_PORT=587`
- [ ] Configurer `SMTP_USER_NAME=noreply@tubenplay.com`
- [ ] Configurer `SMTP_PASSWORD=[mot-de-passe]`
- [ ] Configurer `SMTP_AUTHENTICATION=plain`
- [ ] Configurer `SMTP_ENABLE_STARTTLS=true`
- [ ] Vérifier la configuration

---

## 🆘 Dépannage

### Les emails ne partent pas
1. Vérifier que Private Email est bien activé
2. Vérifier les paramètres SMTP : `heroku config`
3. Vérifier les logs : `heroku logs --tail`

### Erreur "Authentication failed"
- Vérifier le mot de passe de `noreply@tubenplay.com`
- Vérifier que l'adresse email existe bien dans Private Email
- Essayer avec le port 465 (SSL) au lieu de 587 (TLS)

### Erreur "Connection timeout"
- Vérifier que `SMTP_ADDRESS=mail.privateemail.com` est correct
- Vérifier le port (587 ou 465)

---

## 📝 Résumé

1. ✅ **Activer Private Email** sur Namecheap (payant, ~$1-2/mois par boîte)
2. ✅ **Créer les 5 adresses email** dans Private Email
3. ✅ **Noter le mot de passe** de `noreply@tubenplay.com`
4. ✅ **Configurer sur Heroku** avec les paramètres SMTP de Namecheap
5. ✅ **Mettre à jour la base de données** avec les nouveaux emails

**Alternative gratuite :** Utiliser SendGrid ou Mailgun au lieu de Private Email.

---

## 💡 Recommandation

Pour commencer, je recommande **SendGrid** (gratuit jusqu'à 100 emails/jour) car :
- ✅ Gratuit
- ✅ Facile à configurer
- ✅ Fiable
- ✅ Parfait pour tester

Vous pourrez toujours passer à Private Email plus tard si besoin.


