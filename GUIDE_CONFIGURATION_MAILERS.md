# 📧 Guide : Configuration des Mailers avec les Bonnes Adresses

## 🎯 Ce que vous devez faire

**OUI, vous devez remplacer les adresses par défaut** (`from@example.com`, `please-change-me@example.com`) par **votre vraie adresse email**.

---

## 📋 Options de Configuration

Vous avez **3 façons** de configurer les adresses email. Choisissez celle qui vous convient le mieux.

---

## Option 1 : Variables d'Environnement (RECOMMANDÉ pour Heroku)

### ✅ Avantages
- Facile à modifier sans toucher au code
- Sécurisé (pas dans le code source)
- Parfait pour Heroku

### 📝 Ce que vous devez faire

#### 1. **Déterminer votre adresse email d'envoi**

Vous avez besoin d'**une adresse email** qui servira à envoyer les emails aux joueurs.

**Exemples :**
- `noreply@votre-domaine.com` (recommandé pour les emails automatiques)
- `contact@votre-domaine.com`
- `support@votre-domaine.com`

**⚠️ Important :** Cette adresse doit être une adresse **réelle** que vous possédez.

#### 2. **Configurer sur Heroku**

```bash
# 1. Définir le domaine de votre application
heroku config:set MAILER_DOMAIN=votre-domaine.com

# 2. Définir l'adresse expéditeur pour ApplicationMailer
heroku config:set MAILER_FROM_ADDRESS=noreply@votre-domaine.com

# 3. Définir l'adresse expéditeur pour Devise
heroku config:set DEVISE_MAILER_SENDER=noreply@votre-domaine.com
```

**Exemple concret :**
```bash
# Si votre domaine est "tubenplay.com"
heroku config:set MAILER_DOMAIN=tubenplay.com
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com
```

#### 3. **Vérifier la configuration**

```bash
# Voir toutes les variables configurées
heroku config

# Vous devriez voir :
# MAILER_DOMAIN: tubenplay.com
# MAILER_FROM_ADDRESS: noreply@tubenplay.com
# DEVISE_MAILER_SENDER: noreply@tubenplay.com
```

---

## Option 2 : Rails Credentials (Alternative)

### ✅ Avantages
- Tout centralisé dans un fichier
- Pas besoin de variables d'environnement
- Bon pour le développement local

### 📝 Ce que vous devez faire

#### 1. **Éditer les credentials Rails**

```bash
# Ouvrir l'éditeur de credentials
EDITOR="code --wait" rails credentials:edit
# Ou avec vim/nano :
# EDITOR="vim" rails credentials:edit
```

#### 2. **Ajouter la configuration email**

Dans le fichier qui s'ouvre, ajoutez :

```yaml
mailer:
  from_address: noreply@votre-domaine.com

devise:
  mailer_sender: noreply@votre-domaine.com
```

**Exemple complet :**
```yaml
# ... autres credentials existants ...

mailer:
  from_address: noreply@tubenplay.com

devise:
  mailer_sender: noreply@tubenplay.com
```

#### 3. **Sauvegarder et fermer l'éditeur**

Le fichier sera automatiquement chiffré et sauvegardé.

---

## Option 3 : Modifier Directement le Code (NON RECOMMANDÉ)

### ⚠️ Pourquoi ce n'est pas recommandé
- Les adresses sont dans le code source
- Difficile à changer sans redéployer
- Pas flexible

### 📝 Si vous voulez quand même le faire

#### 1. **Modifier `app/mailers/application_mailer.rb`**

```ruby
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@votre-domaine.com"  # ← Remplacez ici
  layout "mailer"
end
```

#### 2. **Modifier `config/initializers/devise.rb`**

```ruby
config.mailer_sender = 'noreply@votre-domaine.com'  # ← Remplacez ici
```

---

## 🎯 Recommandation : Option 1 (Variables d'Environnement)

**Pourquoi ?**
- ✅ Facile à modifier sur Heroku
- ✅ Pas besoin de redéployer pour changer
- ✅ Sécurisé
- ✅ Standard pour les applications en production

---

## 📝 Checklist : Ce que vous devez faire MAINTENANT

### Étape 1 : Choisir votre adresse email
- [ ] Décider de l'adresse : `noreply@votre-domaine.com` ou autre ?
- [ ] Vérifier que vous possédez cette adresse

### Étape 2 : Configurer sur Heroku
- [ ] `heroku config:set MAILER_DOMAIN=votre-domaine.com`
- [ ] `heroku config:set MAILER_FROM_ADDRESS=noreply@votre-domaine.com`
- [ ] `heroku config:set DEVISE_MAILER_SENDER=noreply@votre-domaine.com`

### Étape 3 : Vérifier
- [ ] `heroku config` pour voir les variables
- [ ] Tester l'envoi d'un email (optionnel pour l'instant)

---

## 🔍 Comment ça fonctionne actuellement

### Priorité de Configuration (dans l'ordre)

1. **Variable d'environnement** (si définie) → **UTILISÉE**
2. **Rails Credentials** (si définie) → **UTILISÉE**
3. **Valeur par défaut** → `noreply@example.com` (fallback)

**Exemple :**
```ruby
# Si MAILER_FROM_ADDRESS est défini → utilise cette valeur
# Sinon, si mailer.from_address est dans credentials → utilise cette valeur
# Sinon → utilise "noreply@example.com"
```

---

## ❓ Questions Fréquentes

### Q: Dois-je créer une nouvelle adresse email ?
**R:** Oui, vous devez utiliser une adresse email **réelle** que vous possédez. Si vous n'avez pas de domaine, vous pouvez utiliser Gmail, mais ce n'est pas idéal pour la production.

### Q: Puis-je utiliser mon email personnel ?
**R:** Oui, mais ce n'est pas recommandé. Mieux vaut créer une adresse dédiée comme `noreply@votre-domaine.com`.

### Q: Que se passe-t-il si je ne configure rien ?
**R:** L'application utilisera `noreply@example.com` par défaut, mais :
- ❌ Les emails risquent d'être marqués comme spam
- ❌ Les emails peuvent ne pas partir du tout
- ❌ Pas professionnel

### Q: Dois-je configurer aussi SMTP ?
**R:** Oui ! La configuration SMTP est nécessaire pour **envoyer** les emails. Voir `CONFIGURATION_EMAIL.md` pour les détails.

---

## 🚀 Prochaines Étapes

1. ✅ **Maintenant :** Configurer les adresses email (Option 1 recommandée)
2. ⏳ **Ensuite :** Configurer SMTP pour l'envoi (voir `CONFIGURATION_EMAIL.md`)
3. ⏳ **Puis :** Configurer le DNS sur Heroku
4. ⏳ **Enfin :** Déployer et tester

---

## 💡 Exemple Complet

**Si votre application s'appelle "Tube'NPlay" et votre domaine est "tubenplay.com" :**

```bash
# 1. Configurer le domaine
heroku config:set MAILER_DOMAIN=tubenplay.com

# 2. Configurer l'expéditeur ApplicationMailer
heroku config:set MAILER_FROM_ADDRESS=noreply@tubenplay.com

# 3. Configurer l'expéditeur Devise
heroku config:set DEVISE_MAILER_SENDER=noreply@tubenplay.com

# 4. Vérifier
heroku config | grep MAILER
```

**Résultat :**
- Les emails partiront de `noreply@tubenplay.com`
- Les liens dans les emails pointeront vers `https://tubenplay.com`
- Tout est configuré et prêt !

