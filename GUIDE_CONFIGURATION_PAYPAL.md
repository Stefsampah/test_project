# 💳 Guide Configuration PayPal - Tube'NPlay

## 📋 Étape 1 : Créer un Compte PayPal Business

1. Aller sur https://www.paypal.com/fr/business
2. Créer un compte Business (gratuit)
3. Compléter les informations de votre entreprise
4. Vérifier votre compte (email, téléphone, etc.)

---

## 🔑 Étape 2 : Récupérer les Clés API PayPal

### Mode Sandbox (pour tester avant production)

1. Aller sur https://developer.paypal.com
2. Se connecter avec votre compte PayPal Business
3. **Dashboard** → **My Apps & Credentials**
4. Section **Sandbox** :
   - Cliquer sur **Create App**
   - Nom : "Tube'NPlay Sandbox"
   - Cliquer sur **Create App**
   - **Client ID** : `Ae...` (copier)
   - **Secret** : Cliquer sur **Show** puis copier

### Mode Live (pour la production)

1. Dans le Dashboard PayPal Developer
2. **My Apps & Credentials** → **Live**
3. Cliquer sur **Create App**
4. Nom : "Tube'NPlay Production"
5. Cliquer sur **Create App**
6. **Client ID** : `Ae...` (copier)
7. **Secret** : Cliquer sur **Show** puis copier

⚠️ **IMPORTANT** : Ne jamais partager vos clés secrètes publiquement !

---

## 🚀 Étape 3 : Configurer sur Heroku

### Option A : Via l'Interface Web Heroku

1. Aller sur https://dashboard.heroku.com
2. Sélectionner votre app
3. **Settings** → **Config Vars** → **Reveal Config Vars**
4. Ajouter :
   - `PAYPAL_CLIENT_ID` = `Ae...` (Client ID)
   - `PAYPAL_CLIENT_SECRET` = `...` (Secret)
   - `PAYPAL_MODE` = `sandbox` (pour tester) ou `live` (pour production)

### Option B : Via la CLI Heroku

```bash
# Se connecter à Heroku
heroku login

# Configurer les clés PayPal (Mode Sandbox pour tester)
heroku config:set PAYPAL_CLIENT_ID=Ae... --app votre-app-name
heroku config:set PAYPAL_CLIENT_SECRET=... --app votre-app-name
heroku config:set PAYPAL_MODE=sandbox --app votre-app-name

# Pour la production, utiliser :
heroku config:set PAYPAL_MODE=live --app votre-app-name

# Vérifier que c'est bien configuré
heroku config --app votre-app-name
```

---

## 🧪 Étape 4 : Tester avec le Mode Sandbox

### 1. Configurer le Mode Sandbox

```bash
heroku config:set PAYPAL_MODE=sandbox --app votre-app-name
heroku config:set PAYPAL_CLIENT_ID=Ae... --app votre-app-name
heroku config:set PAYPAL_CLIENT_SECRET=... --app votre-app-name
```

### 2. Créer un Compte Sandbox de Test

1. Dans PayPal Developer Dashboard
2. **Dashboard** → **Sandbox** → **Accounts**
3. Cliquer sur **Create Account**
4. Créer un compte **Personal** (pour tester les paiements)
5. Email et mot de passe seront générés automatiquement

### 3. Tester un Achat

1. Aller sur votre app en production
2. Aller dans la boutique
3. Essayer d'acheter un pack de points
4. Tu seras redirigé vers PayPal Sandbox
5. Se connecter avec le compte Sandbox créé
6. Confirmer le paiement

### 4. Vérifier dans PayPal Dashboard

- Aller dans **Dashboard** → **Sandbox** → **Transactions**
- Tu devrais voir le paiement de test

---

## 🔄 Étape 5 : Passer en Mode Live

### 1. Vérifier que Tout Fonctionne en Sandbox

✅ Les achats fonctionnent
✅ Les points sont crédités
✅ Les abonnements VIP fonctionnent

### 2. Configurer le Mode Live

```bash
heroku config:set PAYPAL_MODE=live --app votre-app-name
heroku config:set PAYPAL_CLIENT_ID=Ae... --app votre-app-name (clés Live)
heroku config:set PAYPAL_CLIENT_SECRET=... --app votre-app-name (clés Live)
```

### 3. Redémarrer l'App

```bash
heroku restart --app votre-app-name
```

### 4. Tester avec une Vraie Transaction (petit montant)

⚠️ **ATTENTION** : En mode Live, les paiements sont réels !

---

## 🔍 Vérification du Mode Simulation

Le code détecte automatiquement si PayPal est configuré.

**Code actuel :**
```ruby
if Rails.configuration.paypal[:client_id].blank? || Rails.configuration.paypal[:client_secret].blank?
  # Mode simulation
else
  # Mode réel PayPal
end
```

**Si les clés ne sont pas configurées**, le mode simulation sera automatiquement activé.

---

## 📊 Étape 6 : Configurer les Webhooks (Optionnel mais Recommandé)

Les webhooks permettent à PayPal de notifier ton app quand un paiement est complété.

### 1. Dans PayPal Developer Dashboard

1. **Dashboard** → **My Apps & Credentials**
2. Sélectionner ton app (Sandbox ou Live)
3. Section **Webhooks**
4. Cliquer sur **Add Webhook**
5. URL : `https://votre-app.herokuapp.com/paypal/webhooks`
6. Événements à écouter :
   - `PAYMENT.SALE.COMPLETED`
   - `PAYMENT.SALE.DENIED`
   - `PAYMENT.CAPTURE.COMPLETED`

### 2. Récupérer l'ID du Webhook

1. Cliquer sur le webhook créé
2. Copier l'**Webhook ID**

### 3. Configurer sur Heroku

```bash
heroku config:set PAYPAL_WEBHOOK_ID=... --app votre-app-name
```

### 4. Créer le Contrôleur Webhook (si nécessaire)

Créer `app/controllers/paypal_webhooks_controller.rb` :

```ruby
class PayPalWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery except: [:create]

  def create
    # Vérifier la signature du webhook
    # Traiter les événements PayPal
    # ...
  end
end
```

---

## ✅ Checklist Finale

- [ ] Compte PayPal Business créé
- [ ] Clés API récupérées (Sandbox et Live)
- [ ] Clés configurées sur Heroku
- [ ] Test effectué avec mode Sandbox
- [ ] Paiement test réussi
- [ ] Clés Live configurées
- [ ] App redémarrée
- [ ] Webhooks configurés (optionnel)

---

## 🆘 Dépannage

### Problème : "Invalid Client ID"

**Solution** : Vérifier que les clés sont bien configurées :
```bash
heroku config --app votre-app-name
```

### Problème : Les achats ne fonctionnent pas

**Solution** : 
1. Vérifier les logs : `heroku logs --tail --app votre-app-name`
2. Vérifier que les clés sont configurées
3. Vérifier que l'app est redémarrée : `heroku restart --app votre-app-name`
4. Vérifier que le mode est correct (sandbox ou live)

### Problème : Mode simulation toujours actif

**Solution** : Vérifier que les clés PayPal sont bien configurées :
```bash
heroku config:get PAYPAL_CLIENT_ID --app votre-app-name
heroku config:get PAYPAL_CLIENT_SECRET --app votre-app-name
```

Si elles sont vides, les configurer.

### Problème : Redirection PayPal ne fonctionne pas

**Solution** : 
1. Vérifier que les URLs de retour sont correctes dans le code
2. Vérifier que l'app est accessible en HTTPS
3. Vérifier les logs PayPal dans le Dashboard

---

## 📞 Support

- **Documentation PayPal** : https://developer.paypal.com/docs
- **Support PayPal** : https://www.paypal.com/support
- **Dashboard PayPal Developer** : https://developer.paypal.com

---

## 💡 Différences avec Stripe

- **PayPal** : Redirige vers PayPal pour le paiement (expérience utilisateur différente)
- **Stripe** : Paiement intégré dans l'app (Checkout Stripe)

**Avantages PayPal** :
- ✅ Plus familier pour les utilisateurs
- ✅ Pas besoin de carte bancaire (compte PayPal)
- ✅ Meilleure acceptation internationale

**Inconvénients PayPal** :
- ⚠️ Redirection vers PayPal (sortie de l'app)
- ⚠️ Expérience utilisateur moins intégrée

---

**🎉 Une fois tout configuré, tu peux déployer et accepter de vrais paiements via PayPal !**

