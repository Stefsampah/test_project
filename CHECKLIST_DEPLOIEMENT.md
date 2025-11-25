# 🚀 Checklist Déploiement - Tube'NPlay

## ✅ CE QUI EST DÉJÀ EN PLACE (Bien !)

### Sécurité de Base
- ✅ **CSRF Protection** : `protect_from_forgery with: :exception` dans ApplicationController
- ✅ **SSL/HTTPS** : `force_ssl = true` en production
- ✅ **Headers de Sécurité** : X-Frame-Options, X-Content-Type-Options, X-XSS-Protection, Referrer-Policy
- ✅ **Authentification** : Devise configuré avec `before_action :authenticate_user!`
- ✅ **SQL Injection** : Toutes les requêtes utilisent des placeholders (sécurisé)
- ✅ **Sanitize** : Utilisation de `sanitize` au lieu de `html_safe` dans ApplicationController

### Configuration Production
- ✅ **Environnement Production** : Configuré avec SSL, headers, logging
- ✅ **i18n** : Français et Anglais configurés
- ✅ **Strong Parameters** : Utilisés dans ProfilesController et Admin::PlaylistsController

---

## ⚠️ À FAIRE AVANT DÉPLOIEMENT (CRITIQUE)

### 1. 🔴 STRIPE - Configuration des Vraies Clés (OBLIGATOIRE)

**Problème actuel :** Stripe est en mode simulation (clé contient "ABC123")

**Fichier :** `config/initializers/stripe.rb`

**À faire :**
1. Créer un compte Stripe en production
2. Récupérer les vraies clés API (publishable_key et secret_key)
3. Configurer les variables d'environnement :
   ```bash
   STRIPE_PUBLISHABLE_KEY=pk_live_...
   STRIPE_SECRET_KEY=sk_live_...
   ```

**Où configurer :**
- **Heroku** : `heroku config:set STRIPE_PUBLISHABLE_KEY=... STRIPE_SECRET_KEY=...`
- **Autre plateforme** : Variables d'environnement de production

**Code actuel :**
```ruby
# config/initializers/stripe.rb
Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY']
}
```

**⚠️ IMPORTANT :** Le code détecte automatiquement le mode simulation. Une fois les vraies clés configurées, les vrais paiements fonctionneront.

---

### 2. 🟡 Strong Parameters - Vérifications

**Fichiers à vérifier :**

#### ✅ Déjà OK :
- `ProfilesController` : Utilise `user_params` avec `permit`
- `Admin::PlaylistsController` : Utilise `playlist_params` avec `permit`

#### ⚠️ À vérifier :
- `SwipesController` : Utilise `params[:video_id]`, `params[:playlist_id]`, `params[:liked]` directement
- `GamesController` : Vérifier les paramètres utilisés
- `StoreController` : Vérifier `params[:pack_id]`, `params[:playlist_id]`

**Recommandation :** Ajouter des validations pour s'assurer que les IDs sont valides.

---

### 3. 🟡 html_safe - Utilisations à Vérifier

**Fichiers avec `html_safe` :**
- `app/views/layouts/application.html.erb` : `notice.html_safe`, `alert.html_safe`, `t('layout.game_in_progress_html').html_safe`
- `app/views/store/index.html.erb` : `flash[:notice].html_safe`
- `app/controllers/store_controller.rb` : `t('store.messages.vip_subscription_activated').html_safe`

**⚠️ Risque :** Si le contenu vient de la base de données ou d'entrées utilisateur, risque XSS.

**Recommandation :** Vérifier que le contenu est sûr (traductions i18n = OK, contenu DB = à vérifier).

---

### 4. 🟡 Variables d'Environnement Production

**Variables requises :**

```bash
# Stripe (OBLIGATOIRE pour les achats)
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...

# Rails
SECRET_KEY_BASE=... (généré automatiquement par Rails/Heroku)
RAILS_ENV=production

# Base de données
DATABASE_URL=... (configuré automatiquement par Heroku)

# Email (optionnel mais recommandé)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USER_NAME=...
SMTP_PASSWORD=...
SMTP_DOMAIN=...

# Host (pour les emails)
HOST=ton-domaine.com
MAILER_DOMAIN=ton-domaine.com
```

---

### 5. 🟢 Validations des Entrées

**Déjà en place :**
- ✅ Modèle User : Validation email stricte
- ✅ Modèle User : Normalisation email
- ✅ Requêtes SQL : Utilisation de placeholders (protection injection SQL)

**À vérifier :**
- Validation des IDs dans les contrôleurs (ex: `params[:playlist_id]` existe bien)

---

## 📋 CHECKLIST FINALE AVANT DÉPLOIEMENT

### Sécurité
- [x] CSRF Protection activée
- [x] SSL/HTTPS forcé en production
- [x] Headers de sécurité configurés
- [x] Authentification sur toutes les routes sensibles
- [x] SQL Injection protégée (placeholders)
- [ ] **Stripe configuré avec vraies clés** ⚠️ CRITIQUE
- [ ] Vérifier les utilisations de `html_safe` (faible risque car traductions i18n)

### Configuration
- [x] Environnement production configuré
- [ ] **Variables d'environnement Stripe configurées** ⚠️ CRITIQUE
- [ ] Variables d'environnement email configurées (optionnel)
- [ ] Host configuré pour les emails

### Tests
- [ ] Tester l'authentification en production
- [ ] Tester un achat Stripe en mode test (avec clés de test)
- [ ] Tester la navigation FR/EN
- [ ] Tester les fonctionnalités principales

---

## 🎯 ACTIONS IMMÉDIATES

### 1. Configurer Stripe (15 minutes)
```bash
# Sur Heroku
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_live_...
heroku config:set STRIPE_SECRET_KEY=sk_live_...
```

### 2. Vérifier les Variables d'Environnement
```bash
# Sur Heroku
heroku config
```

### 3. Tester un Achat en Mode Test
- Utiliser les clés de test Stripe d'abord
- Tester un achat de points
- Vérifier que tout fonctionne

### 4. Déployer
Une fois Stripe configuré, tu peux déployer !

---

## ⚠️ ATTENTION

**NE PAS DÉPLOYER avec les clés Stripe de simulation (ABC123)** - Les achats ne fonctionneront pas en production.

**Solution :** Configure les vraies clés Stripe avant le déploiement final.

---

## 📝 NOTES

- Les utilisations de `html_safe` sont principalement pour les traductions i18n (sûres)
- Les requêtes SQL utilisent toutes des placeholders (sécurisé)
- La protection CSRF est active partout
- SSL est forcé en production

**Tu es presque prêt ! Il ne reste que la configuration Stripe. 🚀**

