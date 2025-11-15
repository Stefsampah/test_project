# 🔧 Résoudre l'Erreur Heroku : "Missing required flag app"

## 🎯 Problème

L'erreur `Missing required flag app` signifie qu'Heroku ne sait pas quelle application utiliser.

---

## 📋 Solution 1 : Vérifier si Vous Avez Déjà une App Heroku

### Vérifier vos Apps Heroku

Exécutez cette commande :

```bash
heroku apps
```

**Si vous voyez une liste d'apps :**
- Notez le nom de votre app (ex: `tubenplay-app` ou `test-project-12345`)
- Utilisez le flag `--app` dans les commandes

**Si vous ne voyez rien ou une erreur :**
- Vous devez créer une nouvelle app Heroku

---

## 📋 Solution 2 : Créer une Nouvelle App Heroku

### Si Vous N'Avez Pas Encore d'App

1. **Créer l'app Heroku** :
```bash
heroku create tubenplay-app
```

(Remplacez `tubenplay-app` par le nom que vous voulez, ou laissez Heroku en générer un)

2. **Vérifier que c'est créé** :
```bash
git remote -v
```

Vous devriez voir `heroku` dans la liste.

---

## 📋 Solution 3 : Utiliser le Flag --app

### Si Vous Avez Déjà une App

Si vous connaissez le nom de votre app Heroku, utilisez le flag `--app` :

```bash
heroku config:set MAILER_DOMAIN=tubenplay.com --app NOM_DE_VOTRE_APP
```

**Exemple :**
```bash
heroku config:set MAILER_DOMAIN=tubenplay.com --app tubenplay-app
```

---

## 🎯 Action Immédiate

### Option A : Créer une Nouvelle App

```bash
# Créer l'app
heroku create tubenplay-app

# Puis configurer
heroku config:set MAILER_DOMAIN=tubenplay.com
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com
# etc.
```

### Option B : Si Vous Avez Déjà une App

```bash
# Lister vos apps
heroku apps

# Utiliser le nom de l'app dans les commandes
heroku config:set MAILER_DOMAIN=tubenplay.com --app NOM_DE_VOTRE_APP
```

---

## 📋 Commande Complète avec --app

Si vous avez déjà une app, voici la commande complète (remplacez `NOM_DE_VOTRE_APP` et `VOTRE_CLE_API`) :

```bash
heroku config:set MAILER_DOMAIN=tubenplay.com --app NOM_DE_VOTRE_APP && \
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com --app NOM_DE_VOTRE_APP && \
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com --app NOM_DE_VOTRE_APP && \
heroku config:set SMTP_ADDRESS=smtp.sendgrid.net --app NOM_DE_VOTRE_APP && \
heroku config:set SMTP_PORT=587 --app NOM_DE_VOTRE_APP && \
heroku config:set SMTP_USER_NAME=apikey --app NOM_DE_VOTRE_APP && \
heroku config:set SMTP_PASSWORD=VOTRE_CLE_API --app NOM_DE_VOTRE_APP && \
heroku config:set SMTP_AUTHENTICATION=plain --app NOM_DE_VOTRE_APP && \
heroku config:set SMTP_ENABLE_STARTTLS=true --app NOM_DE_VOTRE_APP
```

---

## ✅ Checklist

- [ ] J'ai vérifié si j'ai déjà une app : `heroku apps`
- [ ] J'ai créé une nouvelle app OU j'ai noté le nom de mon app existante
- [ ] J'ai configuré Heroku avec les bonnes commandes

---

## 💡 Astuce

**Pour éviter de répéter `--app` à chaque fois :**

Si vous créez une nouvelle app avec `heroku create`, le remote git sera automatiquement configuré et vous n'aurez plus besoin du flag `--app`.

**C'est parti ! Dites-moi ce que vous voyez avec `heroku apps` !** 🚀


