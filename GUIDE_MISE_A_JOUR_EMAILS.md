# 📧 Guide : Mise à Jour des Emails des Utilisateurs

## 🔍 Situation Actuelle

Vos 4 utilisateurs ont actuellement des emails avec le domaine `example.com` :
- **Admin**: `admin@example.com`
- **Jordan**: `user@example.com`
- **Driss**: `driss@example.com`
- **Ja**: `ja@example.com`

## ⚠️ Problème

Avec la validation email renforcée, le domaine `example.com` est **rejeté** car c'est un domaine de test. Ces emails ne pourront plus être utilisés.

## ✅ Solution : Mettre à jour avec des emails sur `tubenplay.com`

### Option 1 : Utiliser le script automatique (RECOMMANDÉ)

1. **Dans la console Rails**, exécutez :
```ruby
load 'mettre_a_jour_emails_utilisateurs.rb'
```

Le script mettra à jour automatiquement :
- `admin@example.com` → `admin@tubenplay.com`
- `user@example.com` → `user@tubenplay.com`
- `driss@example.com` → `driss@tubenplay.com`
- `ja@example.com` → `ja@tubenplay.com`

### Option 2 : Mise à jour manuelle

Dans la console Rails :

```ruby
# Admin
admin = User.find_by(username: 'Admin')
admin.email = 'admin@tubenplay.com'
admin.save

# Jordan
jordan = User.find_by(username: 'Jordan')
jordan.email = 'user@tubenplay.com'  # ou jordan@tubenplay.com
jordan.save

# Driss
driss = User.find_by(username: 'Driss')
driss.email = 'driss@tubenplay.com'
driss.save

# Ja
ja = User.find_by(username: 'Ja')
ja.email = 'ja@tubenplay.com'
ja.save
```

## 📋 Avant de mettre à jour

### 1. Créer les adresses email sur votre hébergeur

Vous devez créer ces 4 adresses email sur votre hébergeur de domaine (OVH, Gandi, etc.) :
- `admin@tubenplay.com`
- `user@tubenplay.com` (ou `jordan@tubenplay.com`)
- `driss@tubenplay.com`
- `ja@tubenplay.com`

**⚠️ Important :** Ces adresses doivent exister sur votre hébergeur avant de les utiliser dans l'application.

### 2. Alternative : Utiliser des emails existants

Si vous préférez utiliser des emails que les utilisateurs possèdent déjà (Gmail, etc.), vous pouvez les mettre à jour avec ces adresses :

```ruby
# Exemple avec des emails Gmail
admin = User.find_by(username: 'Admin')
admin.email = 'votre-email-admin@gmail.com'
admin.save

# etc.
```

## 🎯 Recommandation

**Pour la production :**
1. ✅ Créer les 4 adresses sur `tubenplay.com` sur votre hébergeur
2. ✅ Exécuter le script de mise à jour
3. ✅ Vérifier que les emails sont bien mis à jour

**Pour le développement :**
- Vous pouvez garder `example.com` temporairement en désactivant la validation, mais ce n'est pas recommandé.

## ✅ Après la mise à jour

Vérifiez que tout fonctionne :

```ruby
# Vérifier les emails
User.all.each { |u| puts "#{u.username}: #{u.email}" }

# Tester la connexion avec le nouvel email
admin = User.find_by(username: 'Admin')
admin.valid?  # Devrait retourner true
```

## 🔄 Si vous voulez changer les emails plus tard

Vous pouvez toujours modifier les emails individuellement :

```ruby
user = User.find_by(username: 'Admin')
user.email = 'nouveau-email@tubenplay.com'
user.save
```

