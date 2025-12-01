# Instructions pour la validation Google Search Console

## 📋 Fichier HTML de validation

Si Google Search Console vous a fourni un fichier HTML de validation (ex: `google1234567890abcdef.html`), suivez ces étapes :

### 1. Télécharger le fichier

Google vous a fourni un fichier HTML à télécharger. Notez son nom exact.

### 2. Placer le fichier dans ce dossier

Placez le fichier HTML téléchargé directement dans le dossier `public/` de votre projet.

**Important :** Le fichier doit être à la racine de `public/`, pas dans un sous-dossier.

### 3. Déployer sur Heroku

```bash
# Ajouter le fichier
git add public/google*.html

# Commiter
git commit -m "Add Google Search Console verification file"

# Déployer
git push heroku master
```

### 4. Vérifier l'accessibilité

Une fois déployé, vérifiez que le fichier est accessible :

```bash
# Remplacez par le nom exact de votre fichier
curl https://www.tubenplay.com/google1234567890abcdef.html
```

Vous devriez voir le contenu HTML du fichier.

### 5. Valider dans Google Search Console

Retournez dans Google Search Console et cliquez sur "Vérifier".

---

## ⚠️ Problèmes courants

### Le fichier n'est pas trouvé

1. **Vérifiez le nom du fichier** : Il doit correspondre exactement à celui fourni par Google
2. **Vérifiez l'emplacement** : Le fichier doit être dans `public/`, pas dans un sous-dossier
3. **Vérifiez le déploiement** : Assurez-vous que le fichier a été déployé sur Heroku
4. **Attendez quelques minutes** : Parfois il faut attendre la propagation

### Alternative : Utiliser la méthode "Balise HTML"

Si le fichier HTML ne fonctionne pas, utilisez la méthode "Balise HTML" :

1. Dans Google Search Console, choisissez "Balise HTML"
2. Copiez la balise meta fournie
3. Ajoutez-la dans `app/views/layouts/application.html.erb` dans la section `<head>`
4. Déployez et validez

Cette méthode est souvent plus simple et plus fiable.

