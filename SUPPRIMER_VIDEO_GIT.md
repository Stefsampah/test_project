# Où tu en es + comment débloquer le push GitHub

## Si filter-branch a planté (ex. "unable to write new index file")

- **Pas de reprise possible** : il faut relancer la commande en entier.
- **Ton dépôt est intact** : `master` n’a pas été modifié, tu peux relancer quand tu veux.
- **Obligatoire** : exécute la commande dans **Terminal.app** (ou iTerm), **pas dans le terminal Cursor**, pour éviter la limite qui fait échouer l’écriture de l’index.

## Situation actuelle

1. **Push GitHub refusé** : le fichier `app/assets/images/about/video_tubenplay.mov` (104 Mo) dépasse la limite GitHub (100 Mo).

2. **Déjà fait** :
   - Le fichier est dans `.gitignore` (il ne sera plus ajouté à l’avenir).
   - Un commit "chore: ignore *.mov..." a été fait (9d782de).
   - La vidéo est **toujours dans l’historique** (commit 24edc18), donc le push échouera tant qu’on ne la retire pas de l’historique.

3. **Tentative filter-branch** : elle a planté vers 142/265 avec "unable to write new index file" (souvent limite disque ou sandbox).

## Solution : lancer la commande dans le Terminal macOS (pas dans Cursor)

Ouvre **Terminal** (ou iTerm), va dans le projet, puis exécute **une seule** des deux options.

### Option A – Avec `git filter-branch` (sans rien installer)

```bash
cd /Users/sampahstephane/Documents/webprojects/test_project
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch app/assets/images/about/video_tubenplay.mov' --prune-empty master
```

- Ça peut prendre 2–3 minutes (265 commits).
- À la fin, nettoie les refs de sauvegarde :
  ```bash
  rm -rf .git/refs/original
  git reflog expire --expire=now --all
  git gc --prune=now --aggressive
  ```
- Puis pousse vers GitHub (écrasement de l’historique) :
  ```bash
  git push origin master --force
  ```

### Option B – Avec `git-filter-repo` (plus rapide et robuste)

1. Installer :
   ```bash
   brew install git-filter-repo
   ```
2. Supprimer le fichier de tout l’historique :
   ```bash
   cd /Users/sampahstephane/Documents/webprojects/test_project
   git filter-repo --path app/assets/images/about/video_tubenplay.mov --invert-paths --force
   ```
3. Pousser (force car l’historique a changé) :
   ```bash
  git push origin master --force
   ```

## Après le push

- **GitHub** : `git push origin master` (ou `--force` si tu as utilisé Option A ou B).
- **Heroku** : `git push heroku master` (Heroku n’a pas la limite 100 Mo, tu peux pousser tel quel si tu veux déployer avant de corriger GitHub).

## Note

La vidéo reste sur ton disque dans `app/assets/images/about/video_tubenplay.mov` ; elle n’est plus suivie par Git. Pour la page "About" en production, héberge-la ailleurs (YouTube, Vimeo, S3, etc.) et mets le lien dans la vue.
