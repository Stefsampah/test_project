# 💳 Guide PayPal.me - Tube'NPlay

## 🎯 Qu'est-ce que PayPal.me ?

PayPal.me est un service simple de PayPal qui permet de créer un **lien de paiement personnalisé** que vous pouvez partager. C'est parfait pour :
- ✅ **Compte individuel** (pas besoin de SIRET)
- ✅ **Configuration simple** (pas d'API complexe)
- ✅ **Paiements directs** vers votre compte PayPal

---

## 📋 Étape 1 : Créer votre Lien PayPal.me

### 1.1 Accéder à PayPal.me

1. **Connectez-vous** à votre compte PayPal : https://www.paypal.com
2. Allez sur **https://www.paypal.com/myaccount/settings/paypalme**
3. Ou cherchez "PayPal.me" dans la recherche PayPal

### 1.2 Choisir votre Lien

PayPal vous propose de créer un lien personnalisé. Exemples :

**Format disponible :**
- `paypal.me/votrenom` (si disponible)
- `paypal.me/votrenom123` (si le premier est pris)
- `paypal.me/tubenplay` (si disponible)

**Exemple concret :**
- `paypal.me/stephane`
- `paypal.me/stephanesampah`
- `paypal.me/tubenplay`

### 1.3 Activer le Lien

1. Choisissez votre lien
2. Cliquez sur **"Créer"** ou **"Activer"**
3. Votre lien est maintenant actif !

---

## 📋 Étape 2 : Utiliser PayPal.me dans l'Application

### Option A : Lien Simple (Recommandé pour commencer)

Dans votre application, redirigez simplement vers votre lien PayPal.me avec le montant :

```ruby
# Exemple dans store_controller.rb
def buy_subscription
  if subscription_type == "vip"
    # Rediriger vers PayPal.me avec le montant
    amount = 9.99
    paypal_me_link = "https://paypal.me/VOTRELIEN/#{amount}"
    redirect_to paypal_me_link, allow_other_host: true
  end
end
```

**Format du lien :**
- `https://paypal.me/VOTRELIEN/9.99` (montant fixe)
- `https://paypal.me/VOTRELIEN` (montant libre)

### Option B : Lien avec Description (Plus Pro)

Vous pouvez ajouter une description dans l'URL :

```
https://paypal.me/VOTRELIEN/9.99?locale.x=fr_FR
```

---

## 📋 Étape 3 : Gérer les Paiements Manuellement

Avec PayPal.me, les paiements arrivent directement sur votre compte PayPal. Vous devez :

1. **Vérifier les paiements** dans votre compte PayPal
2. **Activer manuellement** les abonnements VIP dans l'application

### Solution : Créer une Page Admin pour Activer les Abonnements

Créer une page d'administration où vous pouvez :
- Voir les utilisateurs
- Activer manuellement leur abonnement VIP après vérification du paiement PayPal

---

## 📋 Étape 4 : Intégration dans l'Application

### 4.1 Ajouter la Configuration

Créer un fichier de configuration ou ajouter dans `config/application.rb` ou `.env` :

```ruby
# config/initializers/paypal_me.rb
Rails.configuration.paypal_me = {
  link: ENV['PAYPAL_ME_LINK'] || 'paypal.me/votrelien',
  enabled: ENV['PAYPAL_ME_ENABLED'] == 'true'
}
```

### 4.2 Modifier le Contrôleur Store

```ruby
# app/controllers/store_controller.rb
def buy_subscription
  subscription_type = params[:subscription_type]
  
  if subscription_type == "vip"
    if paypal_me_enabled?
      amount = 9.99
      paypal_me_link = "https://#{Rails.configuration.paypal_me[:link]}/#{amount}"
      
      # Stocker en session pour référence
      session[:pending_subscription] = {
        type: 'vip',
        amount: amount,
        user_id: current_user.id
      }
      
      redirect_to paypal_me_link, allow_other_host: true
    elsif current_user.admin?
      # Mode simulation pour admin
      current_user.update!(vip_subscription: true, vip_expires_at: 1.month.from_now)
      redirect_to playlists_path, notice: "Abonnement VIP activé (mode admin)"
    else
      redirect_to store_path, alert: "Paiement non disponible"
    end
  end
end

private

def paypal_me_enabled?
  Rails.configuration.paypal_me[:enabled] && Rails.configuration.paypal_me[:link].present?
end
```

### 4.3 Créer une Page de Confirmation

Créer une page où l'utilisateur confirme avoir effectué le paiement :

```ruby
# app/controllers/store_controller.rb
def payment_confirmation
  # Page où l'utilisateur confirme avoir payé
  # Vous vérifiez ensuite manuellement dans PayPal et activez l'abonnement
end
```

---

## 📋 Étape 5 : Workflow Recommandé

### Workflow Simple :

1. **Utilisateur clique** sur "Acheter VIP" (9.99€)
2. **Redirection** vers `paypal.me/votrelien/9.99`
3. **Utilisateur paie** sur PayPal
4. **Utilisateur revient** sur votre site
5. **Page de confirmation** : "Merci ! Votre paiement est en cours de vérification. Votre abonnement sera activé sous 24h."
6. **Vous vérifiez** dans PayPal et **activez manuellement** l'abonnement

### Workflow Automatisé (Optionnel) :

Si vous voulez automatiser, vous pouvez :
- Demander à l'utilisateur de fournir un **numéro de transaction PayPal**
- Créer une **page admin** pour vérifier et activer rapidement

---

## 📋 Étape 6 : Configuration sur Heroku

```bash
# Configurer votre lien PayPal.me
heroku config:set PAYPAL_ME_LINK=paypal.me/votrelien --app tubenplay-app
heroku config:set PAYPAL_ME_ENABLED=true --app tubenplay-app

# Vérifier
heroku config --app tubenplay-app | grep PAYPAL
```

---

## ✅ Avantages de PayPal.me

- ✅ **Simple** : Pas besoin d'API complexe
- ✅ **Pas de SIRET** : Fonctionne avec un compte individuel
- ✅ **Gratuit** : Pas de frais supplémentaires
- ✅ **Rapide** : Configuration en 5 minutes
- ✅ **Sécurisé** : Utilise PayPal directement

## ⚠️ Inconvénients

- ⚠️ **Activation manuelle** : Vous devez vérifier les paiements et activer les abonnements
- ⚠️ **Pas d'automatisation** : Pas de webhooks automatiques (sauf si vous utilisez l'API PayPal en plus)

---

## 🎯 Exemple de Lien

**Si votre lien est `paypal.me/stephane` :**

- **Abonnement VIP (9.99€)** : `https://paypal.me/stephane/9.99`
- **Montant libre** : `https://paypal.me/stephane`

---

## 📞 Support

- **PayPal.me** : https://www.paypal.com/myaccount/settings/paypalme
- **Documentation PayPal.me** : https://www.paypal.com/paypalme

---

**🎉 Une fois votre lien créé, vous pouvez commencer à recevoir des paiements !**

