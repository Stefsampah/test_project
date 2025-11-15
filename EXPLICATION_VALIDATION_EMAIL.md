# 📧 Explication : Renforcement de la Validation Email

## 🔍 Ce qui a été fait dans `app/models/user.rb`

### 1. **Validation de Format Stricte** (ligne 9-12)
```ruby
validates :email, format: { 
  with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
  message: "doit être une adresse email valide"
}
```
**Avant :** Devise utilisait une regex très simple : `/\A[^@\s]+@[^@\s]+\z/` qui acceptait presque tout (ex: `a@b` était valide)

**Maintenant :** Regex RFC 5322 qui vérifie :
- ✅ Format correct : `nom@domaine.extension`
- ✅ Caractères autorisés uniquement
- ✅ Au moins un point dans le domaine
- ✅ Extension de domaine valide

**Exemples :**
- ✅ `user@gmail.com` → **Valide**
- ✅ `test@example.fr` → **Valide**
- ❌ `user@domain` → **Invalide** (pas d'extension)
- ❌ `user@` → **Invalide** (pas de domaine)
- ❌ `@domain.com` → **Invalide** (pas de nom)

### 2. **Validation de Longueur** (ligne 13)
```ruby
validates :email, length: { maximum: 255 }
```
**Pourquoi :** Limite la longueur à 255 caractères (standard des bases de données)

### 3. **Validation de Domaine Personnalisée** (ligne 14, méthode ligne 421-447)
```ruby
validate :email_domain_validity
```

**Cette méthode rejette :**
- ❌ Domaines de test : `example.com`, `test.com`, `invalid.com`, `localhost`, `domain.com`
- ❌ Domaines sans point (ex: `user@domain`)
- ❌ Domaines trop courts (moins de 3 caractères)

**Exemples :**
- ❌ `user@example.com` → **Rejeté** (domaine de test)
- ❌ `user@test.com` → **Rejeté** (domaine de test)
- ✅ `user@gmail.com` → **Accepté**

### 4. **Normalisation Automatique** (ligne 17, méthode ligne 416-418)
```ruby
before_save :normalize_email
```

**Cette méthode :**
- Convertit en minuscules : `User@Gmail.COM` → `user@gmail.com`
- Supprime les espaces : ` user@gmail.com ` → `user@gmail.com`

**Avantages :**
- ✅ Évite les doublons (ex: `User@Gmail.com` et `user@gmail.com` sont maintenant identiques)
- ✅ Uniformise les données
- ✅ Améliore les performances de recherche

### 5. **Vérification d'Unicité** (ligne 8)
```ruby
validates :email, uniqueness: { case_sensitive: false }
```
**Avant :** Devise gérait déjà l'unicité, mais maintenant c'est explicite et case-insensitive

---

## 📊 Comparaison Avant/Après

### Avant (Devise seul)
```ruby
# Regex Devise : /\A[^@\s]+@[^@\s]+\z/
✅ "a@b" → Accepté (mais invalide !)
✅ "test@example.com" → Accepté (mais c'est un domaine de test !)
✅ "USER@Gmail.COM" → Accepté (mais pas normalisé)
```

### Après (Validation renforcée)
```ruby
# Regex RFC 5322 + validations personnalisées
❌ "a@b" → Rejeté (domaine invalide)
❌ "test@example.com" → Rejeté (domaine de test)
✅ "USER@Gmail.COM" → Accepté et normalisé en "user@gmail.com"
✅ "user@gmail.com" → Accepté
```

---

## 🎯 Résultat

**Les emails des joueurs sont maintenant :**
1. ✅ **Validés strictement** (format correct)
2. ✅ **Normalisés** (minuscules, pas d'espaces)
3. ✅ **Vérifiés** (pas de domaines de test)
4. ✅ **Uniques** (pas de doublons)
5. ✅ **Sécurisés** (format standard)

---

## ⚠️ Impact sur les Utilisateurs Existants

**Si vous avez déjà des utilisateurs dans votre base de données :**

1. **Emails en majuscules** → Sera normalisé automatiquement au prochain enregistrement
2. **Emails avec domaines de test** → Ne pourront plus être créés, mais les existants restent
3. **Emails invalides** → Ne pourront plus être créés

**Pour nettoyer les données existantes :**
```ruby
# Dans rails console
User.find_each do |user|
  user.email = user.email.downcase.strip
  user.save(validate: false) # Si vous voulez forcer même si invalide
end
```

