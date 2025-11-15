# 🚀 Guide : Configurer Heroku avec SendGrid

## 🎯 Configuration Complète

Maintenant que vous avez votre clé API SendGrid, configurons Heroku.

---

## 📋 Étape 1 : Configuration de Base

### Commandes à Exécuter

Ouvrez votre terminal et exécutez ces commandes **une par une** :

```bash
# Configuration du domaine
heroku config:set MAILER_DOMAIN=tubenplay.com

# Configuration de l'adresse expéditeur
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com
```

---

## 📋 Étape 2 : Configuration SMTP SendGrid

### ⚠️ Important : Remplacez VOTRE_CLE_API

**Remplacez `VOTRE_CLE_API` par votre vraie clé API SendGrid** (celle que vous venez de copier).

### Commandes à Exécuter

```bash
# Configuration SMTP SendGrid
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER_NAME=apikey
heroku config:set SMTP_PASSWORD=VOTRE_CLE_API
heroku config:set SMTP_AUTHENTICATION=plain
heroku config:set SMTP_ENABLE_STARTTLS=true
```

### Exemple Concret

Si votre clé API est `SG.abc123xyz456...`, la commande sera :

```bash
heroku config:set SMTP_PASSWORD=SG.abc123xyz456...
```

---

## 📋 Étape 3 : Vérifier la Configuration

### Vérifier Toutes les Variables

```bash
heroku config | grep MAILER
heroku config | grep SMTP
```

### Ce Que Vous Devriez Voir

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

## 🎯 Commande Tout-en-Un (Optionnel)

Si vous préférez tout faire en une fois, voici une commande complète (remplacez `VOTRE_CLE_API`) :

```bash
heroku config:set MAILER_DOMAIN=tubenplay.com && \
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com && \
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com && \
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net && \
heroku config:set SMTP_PORT=587 && \
heroku config:set SMTP_USER_NAME=apikey && \
heroku config:set SMTP_PASSWORD=VOTRE_CLE_API && \
heroku config:set SMTP_AUTHENTICATION=plain && \
heroku config:set SMTP_ENABLE_STARTTLS=true
```

---

## ✅ Checklist

- [ ] `MAILER_DOMAIN=tubenplay.com` configuré
- [ ] `MAILER_FROM_ADDRESS=noreply@tubenplay.com` configuré
- [ ] `DEVISE_MAILER_SENDER=noreply@tubenplay.com` configuré
- [ ] `SMTP_ADDRESS=smtp.sendgrid.net` configuré
- [ ] `SMTP_PORT=587` configuré
- [ ] `SMTP_USER_NAME=apikey` configuré
- [ ] `SMTP_PASSWORD=[votre-clé-api]` configuré (avec votre vraie clé)
- [ ] `SMTP_AUTHENTICATION=plain` configuré
- [ ] `SMTP_ENABLE_STARTTLS=true` configuré
- [ ] Vérification effectuée avec `heroku config`

---

## 🎯 Prochaines Étapes

Une fois Heroku configuré :

1. ✅ **Mettre à jour les emails des utilisateurs** dans la base de données
2. ✅ **Commiter et déployer** le code
3. ✅ **Tester l'envoi d'email**

---

## 🆘 Dépannage

### Erreur "App not found"

**Solution :** Vérifiez que vous êtes dans le bon répertoire et que Heroku CLI est installé.

### Erreur "Authentication failed"

**Vérifications :**
- ✅ La clé API est correctement copiée (sans espaces)
- ✅ Vous avez bien remplacé `VOTRE_CLE_API` par votre vraie clé
- ✅ La clé API commence bien par `SG.`

---

## 💡 Astuce

**Pour copier-coller facilement :**
1. Remplacez `VOTRE_CLE_API` dans la commande par votre vraie clé
2. Copiez toute la commande
3. Collez-la dans votre terminal

**C'est parti ! Configurez Heroku maintenant !** 🚀

