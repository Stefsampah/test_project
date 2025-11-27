# 🖼️ Configuration Cloudinary pour les Avatars

## 📋 Étapes de Configuration

### 1. Créer un compte Cloudinary

1. Allez sur [https://cloudinary.com/](https://cloudinary.com/)
2. Créez un compte gratuit (25GB de stockage/mois)
3. Une fois connecté, allez dans le **Dashboard**

### 2. Récupérer les identifiants Cloudinary

Dans le Dashboard Cloudinary, vous trouverez :
- **Cloud Name** : Le nom de votre cloud (ex: `dxyz12345`)
- **API Key** : Votre clé API
- **API Secret** : Votre secret API

### 3. Configurer les variables d'environnement sur Heroku

Exécutez ces commandes pour configurer Cloudinary sur Heroku :

```bash
heroku config:set CLOUDINARY_CLOUD_NAME=votre_cloud_name -a tubenplay-app
heroku config:set CLOUDINARY_API_KEY=votre_api_key -a tubenplay-app
heroku config:set CLOUDINARY_API_SECRET=votre_api_secret -a tubenplay-app
```

**Remplacez** :
- `votre_cloud_name` par votre Cloud Name
- `votre_api_key` par votre API Key
- `votre_api_secret` par votre API Secret

### 4. Installer les gems

```bash
bundle install
```

### 5. Déployer sur Heroku

```bash
git add .
git commit -m "Configure Cloudinary for Active Storage"
git push heroku master
```

### 6. Réimporter les avatars

Une fois Cloudinary configuré, réimportez les avatars :

```bash
./import_avatars_to_heroku_final.sh
```

## ✅ Vérification

Après la configuration, les avatars seront :
- ✅ Stockés sur Cloudinary (persistant)
- ✅ Accessibles via CDN Cloudinary (rapide)
- ✅ Optimisés automatiquement par Cloudinary
- ✅ Accessibles depuis n'importe où

## 🔧 Configuration Locale (Optionnel)

Pour tester en local, ajoutez dans `.env` :

```
CLOUDINARY_CLOUD_NAME=votre_cloud_name
CLOUDINARY_API_KEY=votre_api_key
CLOUDINARY_API_SECRET=votre_api_secret
```

Et modifiez `config/environments/development.rb` :

```ruby
config.active_storage.service = :cloudinary
```

## 📝 Notes

- Le plan gratuit Cloudinary offre 25GB de stockage et 25GB de bande passante par mois
- Les images sont automatiquement optimisées (WebP, compression)
- Les avatars sont stockés dans le dossier `production` sur Cloudinary
- Les utilisateurs peuvent uploader leurs avatars directement via le formulaire existant

