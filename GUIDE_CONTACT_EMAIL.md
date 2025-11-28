# 📧 Guide : Configurer contact@tubenplay.com avec SendGrid

## 🎯 Objectif

Recevoir tous les messages du formulaire de contact sur **contact@tubenplay.com** via SendGrid.

---

## 📋 Étape 1 : Vérifier la Configuration SendGrid Actuelle

Votre SendGrid est déjà configuré. Vérifions que tout est en place :

```bash
heroku config --app tubenplay-app | grep SMTP
heroku config --app tubenplay-app | grep MAILER
```

Vous devriez voir :
- `SMTP_ADDRESS=smtp.sendgrid.net`
- `SMTP_PASSWORD=SG.xxx...` (votre clé API SendGrid)
- `MAILER_DOMAIN=tubenplay.com`
- `MAILER_FROM_ADDRESS=noreply@tubenplay.com`

---

## 📋 Étape 2 : Configurer l'Email contact@tubenplay.com

### Option A : Utiliser un Forwarder Email (Recommandé)

Si vous avez un hébergeur de domaine (Namecheap, etc.), vous pouvez créer un **forwarder** qui redirige `contact@tubenplay.com` vers votre email personnel.

**Dans Namecheap :**
1. Allez dans **Domain List** → **tubenplay.com** → **Manage**
2. Allez dans **Email Forwarding**
3. Créez un forwarder :
   - **Forwarder** : `contact`
   - **Forward to** : Votre email personnel (ex: `votre.email@gmail.com`)

**Avantages :**
- ✅ Simple et gratuit
- ✅ Les emails arrivent directement dans votre boîte
- ✅ Pas besoin de configurer SendGrid

### Option B : Créer un Compte Email contact@tubenplay.com

Si vous avez un hébergeur qui propose des emails (Namecheap Email, Google Workspace, etc.) :

1. **Créer l'adresse** `contact@tubenplay.com`
2. **Configurer** pour recevoir les emails
3. **Les emails SendGrid** seront envoyés à cette adresse

---

## 📋 Étape 3 : Vérifier que SendGrid Peut Envoyer vers contact@tubenplay.com

### 3.1 Vérifier le Domaine dans SendGrid

1. Allez sur **https://app.sendgrid.com**
2. **Settings** → **Sender Authentication** → **Domain Authentication**
3. Vérifiez que `tubenplay.com` est **"Verified"**

Si ce n'est pas vérifié, suivez les instructions DNS dans `INSTRUCTIONS_DNS_NAMECHEAP.md`.

### 3.2 Tester l'Envoi

Une fois le domaine vérifié, SendGrid peut envoyer depuis n'importe quelle adresse `@tubenplay.com`, y compris `contact@tubenplay.com`.

---

## 📋 Étape 4 : Configurer la Photo de Contact (Cloudinary)

### 4.1 Uploader la Photo sur Cloudinary

1. Allez sur **https://cloudinary.com**
2. **Media Library** → **Upload**
3. Uploadez votre photo
4. **Copiez l'URL** de l'image

### 4.2 Configurer sur Heroku

```bash
heroku config:set CONTACT_PHOTO_URL=https://res.cloudinary.com/votre-cloud/image/upload/v1234567890/votre-photo.jpg --app tubenplay-app
```

**Exemple :**
```bash
heroku config:set CONTACT_PHOTO_URL=https://res.cloudinary.com/du863xqqp/image/upload/v1234567890/contact-photo.jpg --app tubenplay-app
```

---

## 📋 Étape 5 : Tester le Formulaire de Contact

1. **Allez sur** `/contact` (ou `/fr/contact`)
2. **Remplissez le formulaire** avec vos informations
3. **Envoyez le message**
4. **Vérifiez** que vous recevez l'email sur `contact@tubenplay.com`

---

## 🔍 Vérification

### Vérifier que l'Email est Envoyé

```bash
# Voir les logs Heroku
heroku logs --tail --app tubenplay-app

# Chercher les lignes avec "Message de contact envoyé"
```

### Vérifier dans SendGrid

1. Allez sur **SendGrid** → **Activity**
2. Vous devriez voir l'email envoyé vers `contact@tubenplay.com`

---

## ⚠️ Important : Répondre aux Messages

Quand vous recevez un email sur `contact@tubenplay.com`, vous pouvez **répondre directement** à l'email. Le champ `reply-to` est configuré pour que votre réponse aille directement à l'utilisateur qui a envoyé le message.

---

## 🎯 Résumé

1. ✅ **SendGrid configuré** (déjà fait)
2. ✅ **Formulaire de contact créé** (déjà fait)
3. ⏳ **Configurer forwarder email** `contact@tubenplay.com` → votre email
4. ⏳ **Uploader photo sur Cloudinary** et configurer `CONTACT_PHOTO_URL`
5. ⏳ **Tester le formulaire**

---

## 📞 Support

- **SendGrid** : https://app.sendgrid.com
- **Cloudinary** : https://cloudinary.com
- **Namecheap Email Forwarding** : https://www.namecheap.com/support/knowledgebase/article.aspx/9247/2212/how-to-set-up-email-forwarding/

---

**🎉 Une fois configuré, vous recevrez tous les messages de contact sur contact@tubenplay.com !**

