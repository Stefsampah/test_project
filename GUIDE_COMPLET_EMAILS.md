# 📧 Guide Complet : Configuration des Emails

## 🎯 Objectif

Créer les adresses email sur votre hébergeur et configurer l'application pour utiliser `tubenplay.com`.

---

## 📋 Étape 1 : Créer les Adresses Email sur l'Hébergeur

### Adresses à créer (5 au total)

#### 1. Adresse EXPÉDITEUR (pour les mailers)
- **`noreply@tubenplay.com`** ← **OBLIGATOIRE**
- Utilisée pour envoyer les emails automatiques aux joueurs

#### 2. Adresses UTILISATEURS (4 adresses)
- **`admin@tubenplay.com`** (pour Admin)
- **`user@tubenplay.com`** (pour Jordan) - ou `jordan@tubenplay.com` si vous préférez
- **`driss@tubenplay.com`** (pour Driss)
- **`ja@tubenplay.com`** (pour Ja)

### Instructions selon votre hébergeur

#### OVH
1. Connectez-vous à votre espace client OVH
2. Allez dans **Emails** → **Gérer les emails**
3. Cliquez sur **Créer une adresse email**
4. Créez chaque adresse une par une
5. Notez les mots de passe (vous en aurez besoin pour SMTP)

#### Gandi
1. Connectez-vous à votre compte Gandi
2. Allez dans **Emails** → **Créer une boîte email**
3. Créez chaque adresse
4. Configurez les mots de passe

#### Autres hébergeurs
- Cherchez la section **"Emails"** ou **"Boîtes email"**
- Créez les 5 adresses
- Notez les mots de passe

### ⚠️ Important
- **Mots de passe** : Notez-les, vous en aurez besoin pour la configuration SMTP
- **Quota** : Vérifiez que vous avez assez d'espace pour 5 adresses
- **Délai** : La création peut prendre quelques minutes à quelques heures

---

## 📋 Étape 2 : Mettre à Jour les Emails dans la Base de Données

### En Développement Local

1. **Ouvrir la console Rails** :
```bash
rails console
```

2. **Exécuter le script de mise à jour** :
```ruby
load 'mettre_a_jour_emails_utilisateurs.rb'
```

3. **Vérifier que tout est OK** :
```ruby
User.all.each { |u| puts "#{u.username}: #{u.email}" }
```

Vous devriez voir :
```
Admin: admin@tubenplay.com
Jordan: user@tubenplay.com
Driss: driss@tubenplay.com
Ja: ja@tubenplay.com
```

### Sur Heroku (après déploiement)

1. **Accéder à la console Heroku** :
```bash
heroku run rails console
```

2. **Exécuter le script** :
```ruby
load 'mettre_a_jour_emails_utilisateurs.rb'
```

---

## 📋 Étape 3 : Configurer l'Adresse Expéditeur sur Heroku

### Variables d'environnement à configurer

```bash
# 1. Domaine de l'application
heroku config:set MAILER_DOMAIN=tubenplay.com

# 2. Adresse expéditeur pour ApplicationMailer
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com

# 3. Adresse expéditeur pour Devise
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com
```

### Vérifier la configuration

```bash
heroku config | grep MAILER
heroku config | grep DEVISE
```

---

## 📋 Étape 4 : Configurer SMTP sur Heroku

### Informations nécessaires

Vous avez besoin de :
- **Adresse SMTP** de votre hébergeur (ex: `ssl0.ovh.net` pour OVH)
- **Port SMTP** (généralement `587` ou `465`)
- **Email** : `noreply@tubenplay.com`
- **Mot de passe** : Le mot de passe de `noreply@tubenplay.com`

### Configuration selon l'hébergeur

#### OVH
```bash
heroku config:set SMTP_ADDRESS=ssl0.ovh.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=noreply@tubenplay.com
heroku config:set SMTP_PASSWORD=votre-mot-de-passe-noreply
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

#### Gandi
```bash
heroku config:set SMTP_ADDRESS=mail.gandi.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=noreply@tubenplay.com
heroku config:set SMTP_PASSWORD=votre-mot-de-passe-noreply
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

#### Autres hébergeurs
- Consultez la documentation de votre hébergeur pour les paramètres SMTP
- Généralement : `mail.votre-domaine.com` ou `smtp.votre-domaine.com`
- Port : `587` (TLS) ou `465` (SSL)

---

## 📋 Étape 5 : Vérifier la Configuration

### 1. Vérifier les variables d'environnement

```bash
heroku config
```

Vous devriez voir :
```
MAILER_DOMAIN: tubenplay.com
MAILER_FROM_ADDRESS: noreply@tubenplay.com
DEVISE_MAILER_SENDER: noreply@tubenplay.com
SMTP_ADDRESS: ssl0.ovh.net (ou votre serveur)
SMTP_PORT: 587
SMTP_USER_NAME: noreply@tubenplay.com
SMTP_PASSWORD: [masqué]
```

### 2. Tester l'envoi d'email (optionnel)

```bash
heroku run rails console
```

Puis :
```ruby
# Tester avec un utilisateur
user = User.first
# Si vous avez un mailer de test
# UserMailer.welcome_email(user).deliver_now
```

---

## ✅ Checklist Complète

### Sur l'hébergeur
- [ ] Créer `noreply@tubenplay.com`
- [ ] Créer `admin@tubenplay.com`
- [ ] Créer `user@tubenplay.com` (ou `jordan@tubenplay.com`)
- [ ] Créer `driss@tubenplay.com`
- [ ] Créer `ja@tubenplay.com`
- [ ] Noter les mots de passe

### En développement local
- [ ] Mettre à jour les emails dans la base de données
- [ ] Vérifier que les emails sont bien mis à jour

### Sur Heroku
- [ ] Configurer `MAILER_DOMAIN`
- [ ] Configurer `MAILER_FROM_ADDRESS`
- [ ] Configurer `DEVISE_MAILER_SENDER`
- [ ] Configurer les paramètres SMTP
- [ ] Vérifier la configuration

---

## 🔍 Trouver les Paramètres SMTP de Votre Hébergeur

### OVH
- **SMTP** : `ssl0.ovh.net`
- **Port** : `587` (TLS) ou `465` (SSL)
- **Documentation** : https://docs.ovh.com/fr/emails/

### Gandi
- **SMTP** : `mail.gandi.net`
- **Port** : `587`
- **Documentation** : https://docs.gandi.net/fr/simple_hosting/email/

### Autres
- Cherchez "SMTP" dans la documentation de votre hébergeur
- Ou contactez le support

---

## 🚀 Après la Configuration

Une fois tout configuré :

1. **Déployer sur Heroku** :
```bash
git add .
git commit -m "Configuration emails renforcée"
git push heroku ui-experiments:main
```

2. **Vérifier les logs** :
```bash
heroku logs --tail
```

3. **Tester l'application** :
- Tester l'inscription d'un nouvel utilisateur
- Vérifier que les emails partent bien

---

## 🆘 Dépannage

### Les emails ne partent pas
1. Vérifier les paramètres SMTP : `heroku config`
2. Vérifier les logs : `heroku logs --tail`
3. Tester la connexion SMTP dans la console Rails

### Erreur "Authentication failed"
- Vérifier le mot de passe de `noreply@tubenplay.com`
- Vérifier que l'adresse email existe bien sur l'hébergeur

### Erreur "Domain not found"
- Vérifier que `MAILER_DOMAIN=tubenplay.com` est bien configuré
- Vérifier que le DNS est correctement configuré

---

## 📝 Notes Importantes

1. **Sécurité** : Ne jamais commiter les mots de passe dans le code
2. **Test** : Tester d'abord en développement local si possible
3. **Backup** : Faire un backup de la base de données avant de modifier les emails
4. **Délai** : Les emails peuvent prendre quelques minutes à être créés sur l'hébergeur

---

## 🎯 Résumé Rapide

1. ✅ Créer 5 adresses email sur l'hébergeur
2. ✅ Mettre à jour les emails dans la base de données (script)
3. ✅ Configurer les variables d'environnement sur Heroku
4. ✅ Configurer SMTP sur Heroku
5. ✅ Tester et déployer

**C'est parti ! 🚀**

