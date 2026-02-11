# Correction fuite de secrets (GitGuardian – SMTP/credentials)

## Ce qui a été fait dans le code

- **fix_heroku_users.rb** et **definir_mots_de_passe.rb** : les mots de passe en clair ont été remplacés par des **variables d’environnement** (plus aucun secret dans le dépôt).

## À faire de ton côté

### 1. Retirer les anciennes versions des scripts de l’historique Git

Les commits passés contiennent encore les mots de passe. Il faut les supprimer de l’historique avec `git filter-repo` :

```bash
cd /Users/sampahstephane/Documents/webprojects/test_project

# Supprimer ces 2 fichiers de tout l’historique
git filter-repo --invert-paths --path fix_heroku_users.rb --path definir_mots_de_passe.rb --force
```

Ensuite, **remettre les remotes** (filter-repo les enlève) :

```bash
git remote add origin git@github.com:Stefsampah/test_project.git
# heroku reste souvent présent, sinon :
# git remote add heroku https://git.heroku.com/tubenplay-app.git
```

Puis **remettre les versions “propres” des scripts** (déjà modifiées dans ton dépôt) et pousser :

```bash
git add fix_heroku_users.rb definir_mots_de_passe.rb
git commit -m "security: scripts mots de passe via ENV uniquement"
git push origin master --force
git push heroku master --force
```

### 2. Changer les mots de passe des 4 comptes (obligatoire)

Ces comptes ont été exposés dans l’historique Git. Il faut **changer leurs mots de passe** :

- admin@tubenplay.com  
- user@tubenplay.com  
- driss@tubenplay.com  
- ja@tubenplay.com  

Sur Heroku :

- Soit via l’app (réinitialisation mot de passe / “mot de passe oubli”) pour chaque compte.
- Soit en définissant de nouveaux mots de passe via les variables d’environnement puis en relançant une fois le script (voir ci‑dessous).

Pour utiliser les scripts avec des mots de passe **sans les mettre dans le dépôt** :

- **fix_heroku_users.rb** : variables `FIX_HEROKU_ADMIN_PW`, `FIX_HEROKU_USER_PW`, `FIX_HEROKU_DRISS_PW`, `FIX_HEROKU_JA_PW` (ex. `heroku config:set FIX_HEROKU_ADMIN_PW=nouveau_mot_de_passe`).
- **definir_mots_de_passe.rb** : variables `PASSWORDS_ADMIN`, `PASSWORDS_USER`, `PASSWORDS_DRISS`, `PASSWORDS_JA`.

### 3. Désabonnement aux alertes GitGuardian

- Dans l’email GitGuardian : cliquer sur le lien **“Unsubscribe”** en bas du message.  
- Ou aller sur [gitguardian.com](https://www.gitguardian.com), te connecter, puis gérer les préférences de notifications / désabonnement aux alertes.

### 4. (Optionnel) SMTP

Si GitGuardian signale aussi des **identifiants SMTP** (serveur mail) :

- Vérifier qu’aucun fichier ne contient d’adresse SMTP, utilisateur ou mot de passe en clair.
- En production, utiliser uniquement des variables d’environnement (ex. `SMTP_ADDRESS`, `SMTP_USER_NAME`, `SMTP_PASSWORD`) ou les Rails credentials, jamais de secrets dans le dépôt.

---

**Résumé :**  
1) Lancer `git filter-repo` pour supprimer les 2 scripts de l’historique.  
2) Remettre les remotes, committer les versions “ENV only” et push `--force`.  
3) Changer les 4 mots de passe exposés.  
4) Désabonnement GitGuardian via le lien dans l’email ou le site.
