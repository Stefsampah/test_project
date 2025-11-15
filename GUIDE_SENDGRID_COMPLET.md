# 📧 Guide Complet : Configuration SendGrid (Gratuit)

## 🎯 Pourquoi SendGrid ?

- ✅ **Gratuit** jusqu'à 100 emails/jour
- ✅ **Facile à configurer**
- ✅ **Fiable et professionnel**
- ✅ **Parfait pour commencer**

---

## 📋 Étape 1 : Créer un Compte SendGrid

### 1.1 Inscription

1. Allez sur **https://sendgrid.com**
2. Cliquez sur **"Start for free"** ou **"Sign Up"**
3. Remplissez le formulaire :
   - **Email** : Votre email
   - **Password** : Créez un mot de passe fort
   - **Company** : Votre nom ou "Tube'NPlay"
   - **Website** : `tubenplay.com`
4. Acceptez les conditions
5. Cliquez sur **"Create Account"**

### 1.2 Vérification de l'Email

1. Vérifiez votre boîte email
2. Cliquez sur le lien de vérification dans l'email de SendGrid
3. Connectez-vous à votre compte SendGrid

### 1.3 Configuration Initiale

SendGrid vous demandera quelques informations :
- **Use case** : Sélectionnez "Transactional Email" (emails transactionnels)
- **Language** : Français (si disponible) ou English
- Cliquez sur **"Get Started"**

---

## 📋 Étape 2 : Créer une Clé API

### 2.1 Accéder aux API Keys

1. Dans le tableau de bord SendGrid, cliquez sur **"Settings"** (en haut à droite)
2. Dans le menu de gauche, cliquez sur **"API Keys"**

### 2.2 Créer une Nouvelle Clé API

1. Cliquez sur **"Create API Key"** (en haut à droite)
2. Donnez un nom à votre clé : `TubeNPlay Production` ou `Heroku App`
3. Choisissez les permissions : **"Full Access"** (pour simplifier) ou **"Restricted Access"** avec seulement "Mail Send"
4. Cliquez sur **"Create & View"**

### 2.3 ⚠️ IMPORTANT : Copier la Clé API

**⚠️ ATTENTION :** SendGrid affiche la clé API **UNE SEULE FOIS**. Copiez-la immédiatement !

La clé ressemble à : `SG.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

**Notez cette clé dans un endroit sûr !** Vous en aurez besoin pour configurer Heroku.

---

## 📋 Étape 3 : Vérifier Votre Domaine (Optionnel mais Recommandé)

### 3.1 Pourquoi Vérifier le Domaine ?

- ✅ Les emails partiront de `noreply@tubenplay.com` (au lieu de SendGrid)
- ✅ Meilleure délivrabilité (moins de spam)
- ✅ Plus professionnel

### 3.2 Étapes de Vérification

1. Dans SendGrid, allez dans **"Settings"** → **"Sender Authentication"**
2. Cliquez sur **"Authenticate Your Domain"**
3. Sélectionnez votre fournisseur DNS : **Namecheap**
4. Suivez les instructions pour ajouter les enregistrements DNS

**Note :** Si c'est trop compliqué, vous pouvez sauter cette étape pour l'instant. SendGrid fonctionnera quand même, mais les emails partiront de `noreply@sendgrid.net` au lieu de `noreply@tubenplay.com`.

---

## 📋 Étape 4 : Configurer SendGrid sur Heroku

### 4.1 Configuration SMTP

Exécutez ces commandes dans votre terminal :

```bash
# Configuration de base
heroku config:set MAILER_DOMAIN=tubenplay.com
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com

# Configuration SMTP SendGrid
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=apikey
heroku config:set SMTP_PASSWORD=votre-clé-api-sendgrid
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

**⚠️ Remplacez `votre-clé-api-sendgrid`** par la clé API que vous avez copiée à l'étape 2.3 !

### 4.2 Exemple Concret

Si votre clé API est `SG.abc123xyz456...`, la commande sera :

```bash
heroku config:set SMTP_PASSWORD=SG.abc123xyz456...
```

### 4.3 Vérifier la Configuration

```bash
heroku config | grep MAILER
heroku config | grep SMTP
```

Vous devriez voir :
```
MAILER_DOMAIN: tubenplay.com
MAILER_FROM_ADDRESS: noreply@tubenplay.com
DEVISE_MAILER_SENDER: noreply@tubenplay.com
SMTP_ADDRESS: smtp.sendgrid.net
SMTP_PORT: 587
SMTP_USER_NAME: apikey
SMTP_PASSWORD: SG.xxxxxxxxxxxxx...
SMTP_AUTHENTICATION: plain
SMTP_ENABLE_STARTTLS: true
```

---

## 📋 Étape 5 : Mettre à Jour les Emails des Utilisateurs

### 5.1 En Développement Local

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

### 5.2 Sur Heroku (après déploiement)

```bash
heroku run rails console
```

Puis :
```ruby
load 'mettre_a_jour_emails_utilisateurs.rb'
```

---

## 📋 Étape 6 : Tester l'Envoi d'Email

### 6.1 Tester dans la Console Rails (Heroku)

```bash
heroku run rails console
```

Puis :
```ruby
# Tester avec un utilisateur
user = User.first

# Si vous avez un mailer de test, décommentez :
# UserMailer.welcome_email(user).deliver_now

# Sinon, tester avec Devise (reset password)
user.send_reset_password_instructions
```

### 6.2 Vérifier les Logs

```bash
heroku logs --tail
```

Cherchez les messages d'envoi d'email ou les erreurs.

### 6.3 Vérifier dans SendGrid

1. Allez dans SendGrid → **"Activity"**
2. Vous devriez voir les emails envoyés
3. Vérifiez le statut (Delivered, Bounced, etc.)

---

## ✅ Checklist Complète

### Sur SendGrid
- [ ] Compte créé et vérifié
- [ ] Clé API créée et copiée
- [ ] (Optionnel) Domaine vérifié

### Sur Heroku
- [ ] `MAILER_DOMAIN=tubenplay.com` configuré
- [ ] `MAILER_FROM_ADDRESS=noreply@tubenplay.com` configuré
- [ ] `DEVISE_MAILER_SENDER=noreply@tubenplay.com` configuré
- [ ] `SMTP_ADDRESS=smtp.sendgrid.net` configuré
- [ ] `SMTP_PORT=587` configuré
- [ ] `SMTP_USER_NAME=apikey` configuré
- [ ] `SMTP_PASSWORD=[votre-clé-api]` configuré
- [ ] `SMTP_AUTHENTICATION=plain` configuré
- [ ] `SMTP_ENABLE_STARTTLS=true` configuré

### Base de Données
- [ ] Emails des utilisateurs mis à jour
- [ ] Vérification que les emails sont valides

### Test
- [ ] Test d'envoi d'email réussi
- [ ] Vérification dans SendGrid Activity

---

## 🆘 Dépannage

### Erreur "Authentication failed"

**Cause :** Clé API incorrecte ou mal copiée

**Solution :**
1. Vérifier que la clé API est bien copiée (sans espaces)
2. Vérifier dans SendGrid que la clé API est active
3. Recréer une nouvelle clé API si nécessaire

### Erreur "Connection timeout"

**Cause :** Problème de connexion au serveur SMTP

**Solution :**
1. Vérifier que `SMTP_ADDRESS=smtp.sendgrid.net` est correct
2. Essayer avec le port 465 (SSL) :
```bash
heroku config:set SMTP_PORT=465
heroku config:set SMTP_ENABLE_STARTTLS=false
```

### Les emails ne partent pas

**Vérifications :**
1. Vérifier les logs : `heroku logs --tail`
2. Vérifier la configuration : `heroku config | grep SMTP`
3. Vérifier dans SendGrid → Activity si les emails sont envoyés
4. Vérifier que vous n'avez pas dépassé la limite de 100 emails/jour (gratuit)

### Erreur "Invalid API Key"

**Solution :**
1. Vérifier que vous utilisez bien `apikey` comme `SMTP_USER_NAME`
2. Vérifier que la clé API est correcte dans `SMTP_PASSWORD`
3. Vérifier que la clé API n'a pas été supprimée dans SendGrid

---

## 📊 Limites du Plan Gratuit SendGrid

- ✅ **100 emails/jour** (gratuit)
- ✅ **40 000 emails/mois** (gratuit)
- ✅ Support par email
- ✅ API complète

**Si vous dépassez :**
- SendGrid vous proposera un plan payant
- Ou vous pouvez créer un autre compte gratuit

---

## 🔒 Sécurité

### Bonnes Pratiques

1. ✅ **Ne jamais commiter la clé API** dans le code
2. ✅ **Utiliser les variables d'environnement** (déjà fait avec Heroku)
3. ✅ **Restreindre les permissions** de la clé API si possible
4. ✅ **Régénérer la clé API** si elle est compromise

### Vérifier la Sécurité

```bash
# Vérifier que la clé API n'est pas dans le code
git grep "SG\."
# Ne devrait rien retourner
```

---

## 📝 Résumé des Commandes

### Configuration Complète (à copier-coller)

```bash
# Remplacez YOUR_SENDGRID_API_KEY par votre vraie clé API
heroku config:set MAILER_DOMAIN=tubenplay.com
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=apikey
heroku config:set SMTP_PASSWORD=YOUR_SENDGRID_API_KEY
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

---

## 🎯 Prochaines Étapes

1. ✅ Créer le compte SendGrid
2. ✅ Créer la clé API
3. ✅ Configurer sur Heroku
4. ✅ Mettre à jour les emails des utilisateurs
5. ✅ Tester l'envoi d'email
6. ✅ Déployer et vérifier

**C'est parti ! 🚀**


