# 🔒 Sécurité Avant Déploiement : Checklist Complète

## ⚠️ Important : À Faire AVANT le Déploiement

Cette checklist doit être complétée **AVANT** de déployer sur Heroku en production.

---

## ✅ Ce Qui Est Déjà en Place (Bien !)

### 1. CSRF Protection
- ✅ Rails active CSRF par défaut
- ✅ `csrf_meta_tags` présent dans les layouts
- ✅ Tokens CSRF utilisés dans les requêtes AJAX

### 2. SSL/HTTPS
- ✅ `force_ssl = true` en production
- ✅ `assume_ssl = true` configuré

### 3. Filtrage des Paramètres Sensibles
- ✅ Paramètres sensibles filtrés des logs (password, email, token, etc.)

### 4. Authentification
- ✅ Devise configuré avec authentification
- ✅ `before_action :authenticate_user!` sur les contrôleurs sensibles

---

## ⚠️ À Améliorer AVANT le Déploiement

### 1. CSRF Protection Explicite

**Problème :** `protect_from_forgery` n'est pas explicite dans `ApplicationController`

**Solution :** Ajouter explicitement la protection CSRF

**Fichier :** `app/controllers/application_controller.rb`

```ruby
class ApplicationController < ActionController::Base
  # Protection CSRF explicite
  protect_from_forgery with: :exception
  
  # ... reste du code
end
```

### 2. Sécuriser `html_safe` dans ApplicationController

**Problème :** Utilisation de `html_safe` qui peut être dangereuse

**Fichier :** `app/controllers/application_controller.rb` (ligne 9)

**Solution :** Utiliser `sanitize` ou `content_tag` à la place

```ruby
# Au lieu de :
render html: "...".html_safe

# Utiliser :
render html: sanitize("...")
```

### 3. Protection contre SQL Injection

**Problème :** Requête avec LIKE dans `user.rb` (ligne 405)

**Fichier :** `app/models/user.rb`

**Solution :** La requête utilise déjà des placeholders (bon !), mais vérifions qu'elle est sécurisée :

```ruby
# Actuel (déjà sécurisé avec placeholders) :
Playlist.where("LOWER(title) LIKE ? OR LOWER(title) LIKE ? OR LOWER(title) LIKE ?", 
               "%reward%", "%récompense%", "%challenge%")

# C'est déjà sécurisé ! Les placeholders protègent contre l'injection SQL
```

### 4. Strong Parameters

**Vérification :** S'assurer que tous les contrôleurs utilisent strong parameters

**Fichiers à vérifier :**
- `app/controllers/profiles_controller.rb` ✅ (utilise `user_params`)
- `app/controllers/games_controller.rb` ✅ (pas de paramètres utilisateur directs)
- Tous les autres contrôleurs

### 5. Headers de Sécurité

**À Ajouter :** Headers de sécurité supplémentaires

**Fichier :** `config/environments/production.rb`

```ruby
# Headers de sécurité
config.force_ssl = true  # ✅ Déjà présent

# Ajouter après la ligne force_ssl :
config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '1; mode=block',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
}
```

### 6. Content Security Policy (CSP)

**Fichier :** `config/initializers/content_security_policy.rb`

**Solution :** Activer la CSP pour la production

```ruby
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data, 'https://i.ytimg.com'  # Pour YouTube thumbnails
    policy.object_src  :none
    policy.script_src  :self, :https, 'https://www.youtube.com'  # Pour YouTube embeds
    policy.style_src   :self, :https, :unsafe_inline  # Si vous utilisez Tailwind inline
    policy.frame_src   :self, 'https://www.youtube.com'  # Pour YouTube iframes
  end

  # Générer des nonces pour les scripts inline
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src style-src)
end
```

---

## 📋 Checklist de Sécurité

### Avant le Déploiement

- [ ] **CSRF Protection** : Ajouter `protect_from_forgery` dans ApplicationController
- [ ] **html_safe** : Sécuriser l'utilisation de `html_safe` dans ApplicationController
- [ ] **Headers de Sécurité** : Ajouter les headers de sécurité en production
- [ ] **Content Security Policy** : Activer et configurer la CSP
- [ ] **Strong Parameters** : Vérifier que tous les contrôleurs les utilisent
- [ ] **Validation des Entrées** : Vérifier que toutes les entrées utilisateur sont validées
- [ ] **Secrets** : Vérifier que tous les secrets sont dans les variables d'environnement
- [ ] **Logs** : Vérifier que les logs ne contiennent pas d'informations sensibles

### Après le Déploiement

- [ ] **Tester l'Authentification** : Vérifier que l'authentification fonctionne
- [ ] **Tester CSRF** : Vérifier que les requêtes sans token CSRF sont rejetées
- [ ] **Tester HTTPS** : Vérifier que HTTP redirige vers HTTPS
- [ ] **Vérifier les Headers** : Utiliser un outil comme securityheaders.com
- [ ] **Tester les Validations** : Vérifier que les validations fonctionnent

---

## 🔧 Corrections à Apporter

### 1. ApplicationController - CSRF Explicite

**Fichier :** `app/controllers/application_controller.rb`

```ruby
class ApplicationController < ActionController::Base
  # Protection CSRF explicite
  protect_from_forgery with: :exception
  
  def sign_out_redirect
    # ... reste du code
  end
end
```

### 2. ApplicationController - Sécuriser html_safe

**Fichier :** `app/controllers/application_controller.rb`

```ruby
def sign_out_redirect
  render html: sanitize("
    <form id='signout-form' method='post' action='#{destroy_user_session_path}'>
      <input name='_method' type='hidden' value='delete' />
      <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}' />
    </form>
    <script>document.getElementById('signout-form').submit();</script>
  ")
end
```

### 3. Headers de Sécurité

**Fichier :** `config/environments/production.rb`

Ajouter après la ligne `config.force_ssl = true` :

```ruby
# Headers de sécurité
config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '1; mode=block',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
}
```

### 4. Content Security Policy

**Fichier :** `config/initializers/content_security_policy.rb`

Décommenter et configurer (voir exemple ci-dessus).

---

## 🎯 Priorité

### Critique (À Faire Avant Déploiement)
1. ✅ **CSRF Protection Explicite** - 2 minutes
2. ✅ **Headers de Sécurité** - 2 minutes
3. ✅ **Sécuriser html_safe** - 2 minutes

### Important (Recommandé)
4. ✅ **Content Security Policy** - 5 minutes

### Optionnel (Peut Attendre)
5. ⚠️ **Améliorations supplémentaires** - Plus tard

---

## 🚀 Action Immédiate

**Avant de déployer, faites ces 3 corrections critiques :**

1. Ajouter `protect_from_forgery` dans ApplicationController
2. Ajouter les headers de sécurité en production
3. Sécuriser `html_safe` dans ApplicationController

**Cela prendra moins de 10 minutes et améliorera significativement la sécurité !**

---

## 📝 Résumé

**À Faire AVANT le Déploiement :**
- ✅ CSRF Protection Explicite
- ✅ Headers de Sécurité
- ✅ Sécuriser html_safe

**Recommandé :**
- ✅ Content Security Policy

**Déjà en Place (Bien !) :**
- ✅ SSL/HTTPS
- ✅ Filtrage des paramètres sensibles
- ✅ Authentification Devise
- ✅ Strong Parameters (déjà utilisé)

**Voulez-vous que je vous aide à appliquer ces corrections maintenant ?** 🔒


