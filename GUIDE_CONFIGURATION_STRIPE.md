# 💳 Guide Configuration Stripe - Tube'NPlay

## 📋 Étape 1 : Créer un Compte Stripe

1. Aller sur https://stripe.com
2. Créer un compte (gratuit)
3. Compléter les informations de votre entreprise
4. Activer le mode Live (après vérification)

---

## 🔑 Étape 2 : Récupérer les Clés API

### Mode Test (pour tester avant production)

1. Dans le Dashboard Stripe → **Developers** → **API keys**
2. Section **Test mode** :
   - **Publishable key** : `pk_test_...`
   - **Secret key** : `sk_test_...` (cliquer sur "Reveal test key")

### Mode Live (pour la production)

1. Dans le Dashboard Stripe → **Developers** → **API keys**
2. **Activer le mode Live** (switch en haut à droite)
3. Section **Live mode** :
   - **Publishable key** : `pk_live_...`
   - **Secret key** : `sk_live_...` (cliquer sur "Reveal live key")

⚠️ **IMPORTANT** : Ne jamais partager vos clés secrètes (sk_...) publiquement !

---

## 🚀 Étape 3 : Configurer sur Heroku

### Option A : Via l'Interface Web Heroku

1. Aller sur https://dashboard.heroku.com
2. Sélectionner votre app
3. **Settings** → **Config Vars** → **Reveal Config Vars**
4. Ajouter :
   - `STRIPE_PUBLISHABLE_KEY` = `pk_live_...` (ou `pk_test_...` pour tester)
   - `STRIPE_SECRET_KEY` = `sk_live_...` (ou `sk_test_...` pour tester)

### Option B : Via la CLI Heroku

```bash
# Se connecter à Heroku
heroku login

# Configurer les clés Stripe
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_live_... --app votre-app-name
heroku config:set STRIPE_SECRET_KEY=sk_live_... --app votre-app-name

# Vérifier que c'est bien configuré
heroku config --app votre-app-name
```

---

## 🧪 Étape 4 : Tester avec les Clés de Test

### 1. Configurer les Clés de Test

```bash
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_test_... --app votre-app-name
heroku config:set STRIPE_SECRET_KEY=sk_test_... --app votre-app-name
```

### 2. Tester un Achat

1. Aller sur votre app en production
2. Aller dans la boutique
3. Essayer d'acheter un pack de points
4. Utiliser une carte de test Stripe :
   - **Numéro** : `4242 4242 4242 4242`
   - **Date** : N'importe quelle date future (ex: 12/25)
   - **CVC** : N'importe quel 3 chiffres (ex: 123)
   - **Code postal** : N'importe quel code postal (ex: 12345)

### 3. Vérifier dans Stripe Dashboard

- Aller dans **Payments** → **Test mode**
- Tu devrais voir le paiement de test

---

## 🔄 Étape 5 : Passer en Mode Live

### 1. Vérifier que Tout Fonctionne en Test

✅ Les achats fonctionnent
✅ Les points sont crédités
✅ Les abonnements VIP fonctionnent

### 2. Configurer les Clés Live

```bash
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_live_... --app votre-app-name
heroku config:set STRIPE_SECRET_KEY=sk_live_... --app votre-app-name
```

### 3. Redémarrer l'App

```bash
heroku restart --app votre-app-name
```

### 4. Tester avec une Vraie Carte (petit montant)

⚠️ **ATTENTION** : En mode Live, les paiements sont réels !

---

## 🔍 Vérification du Mode Simulation

Le code détecte automatiquement le mode simulation si la clé secrète contient "ABC123".

**Code actuel :**
```ruby
if Rails.configuration.stripe[:secret_key].include?('ABC123')
  # Mode simulation
else
  # Mode réel Stripe
end
```

**Une fois les vraies clés configurées**, le mode simulation sera automatiquement désactivé.

---

## 📊 Étape 6 : Configurer les Webhooks (Optionnel mais Recommandé)

Les webhooks permettent à Stripe de notifier ton app quand un paiement est complété.

### 1. Dans Stripe Dashboard

1. **Developers** → **Webhooks**
2. **Add endpoint**
3. URL : `https://votre-app.herokuapp.com/stripe/webhooks`
4. Événements à écouter :
   - `checkout.session.completed`
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`

### 2. Récupérer le Secret du Webhook

1. Cliquer sur le webhook créé
2. Copier le **Signing secret** (commence par `whsec_...`)

### 3. Configurer sur Heroku

```bash
heroku config:set STRIPE_WEBHOOK_SECRET=whsec_... --app votre-app-name
```

### 4. Créer le Contrôleur Webhook (si pas déjà fait)

Créer `app/controllers/stripe_webhooks_controller.rb` :

```ruby
class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery except: [:create]

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      handle_checkout_session(session)
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
      handle_payment_intent(payment_intent)
    end

    render json: { received: true }
  end

  private

  def handle_checkout_session(session)
    # Traiter la session de checkout complétée
    Rails.logger.info "Checkout session completed: #{session.id}"
  end

  def handle_payment_intent(payment_intent)
    # Traiter le paiement réussi
    Rails.logger.info "Payment intent succeeded: #{payment_intent.id}"
  end
end
```

### 5. Ajouter la Route

Dans `config/routes.rb` :

```ruby
post 'stripe/webhooks', to: 'stripe_webhooks#create'
```

---

## ✅ Checklist Finale

- [ ] Compte Stripe créé
- [ ] Clés API récupérées (test et live)
- [ ] Clés configurées sur Heroku
- [ ] Test effectué avec clés de test
- [ ] Paiement test réussi
- [ ] Clés live configurées
- [ ] App redémarrée
- [ ] Webhooks configurés (optionnel)

---

## 🆘 Dépannage

### Problème : "Invalid API Key"

**Solution** : Vérifier que les clés sont bien configurées :
```bash
heroku config --app votre-app-name
```

### Problème : Les achats ne fonctionnent pas

**Solution** : 
1. Vérifier les logs : `heroku logs --tail --app votre-app-name`
2. Vérifier que les clés ne contiennent pas "ABC123"
3. Vérifier que l'app est redémarrée : `heroku restart --app votre-app-name`

### Problème : Mode simulation toujours actif

**Solution** : Vérifier que la clé secrète ne contient pas "ABC123". Si elle contient "ABC123", c'est normal (mode simulation). Remplace-la par une vraie clé Stripe.

---

## 📞 Support

- **Documentation Stripe** : https://stripe.com/docs
- **Support Stripe** : https://support.stripe.com
- **Dashboard Stripe** : https://dashboard.stripe.com

---

**🎉 Une fois tout configuré, tu peux déployer et accepter de vrais paiements !**

