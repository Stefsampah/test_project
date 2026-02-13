# Définir de nouveaux mots de passe (Heroku)

Les 4 comptes suivants ont été exposés. Il faut leur attribuer **de nouveaux mots de passe** via les variables d'environnement Heroku, puis lancer le script.

## Étape 1 – Choisir 4 nouveaux mots de passe

Choisis **4 mots de passe forts** (au moins 12 caractères, avec majuscules, minuscules, chiffres et symboles). Exemple de format : `MonNouveauMot2Passe!`

- Admin : `admin@tubenplay.com`
- User (Jordan) : `user@tubenplay.com`
- Driss : `driss@tubenplay.com`
- Ja : `ja@tubenplay.com`

Tu peux en générer avec : https://passwordsgenerator.net/ (coche "Symbols").

---

## Étape 2 – Définir les variables sur Heroku

Dans le terminal, depuis le dossier du projet :

```bash
cd /Users/sampahstephane/Documents/webprojects/test_project

heroku config:set \
  FIX_HEROKU_ADMIN_PW="TON_NOUVEAU_MOT_DE_PASSE_ADMIN" \
  FIX_HEROKU_USER_PW="TON_NOUVEAU_MOT_DE_PASSE_USER" \
  FIX_HEROKU_DRISS_PW="TON_NOUVEAU_MOT_DE_PASSE_DRISS" \
  FIX_HEROKU_JA_PW="TON_NOUVEAU_MOT_DE_PASSE_JA" \
  --app tubenplay-app
```

Remplace `TON_NOUVEAU_MOT_DE_PASSE_*` par les vrais mots de passe que tu as choisis.  
Si un mot de passe contient des caractères spéciaux (`$`, `"`, `!`, etc.), mets-le entre **guillemets simples** pour éviter que le shell l’interprète :

```bash
heroku config:set FIX_HEROKU_ADMIN_PW='MonMot2Passe$ecure!' --app tubenplay-app
heroku config:set FIX_HEROKU_USER_PW='AutreMot2Passe!' --app tubenplay-app
# etc.
```

---

## Étape 3 – Lancer le script sur Heroku

Une fois les variables définies :

```bash
heroku run "rails runner fix_heroku_users.rb" --app tubenplay-app
```

Tu devrais voir dans la sortie des lignes du type :
`✅ Mot de passe mis à jour pour admin@tubenplay.com` (et idem pour les 3 autres).

---

## Étape 4 – Supprimer les variables (recommandé)

Pour ne pas laisser les mots de passe dans la config Heroku plus longtemps que nécessaire :

```bash
heroku config:unset FIX_HEROKU_ADMIN_PW FIX_HEROKU_USER_PW FIX_HEROKU_DRISS_PW FIX_HEROKU_JA_PW --app tubenplay-app
```

Les comptes gardent leurs nouveaux mots de passe ; seules les variables d’environnement sont supprimées.

---

## Résumé des commandes (à adapter avec tes vrais mots de passe)

```bash
# 1. Définir les 4 mots de passe (remplacer par tes vrais mots de passe)
heroku config:set FIX_HEROKU_ADMIN_PW='NouveauMDP_Admin_2025!' FIX_HEROKU_USER_PW='NouveauMDP_User_2025!' FIX_HEROKU_DRISS_PW='NouveauMDP_Driss_2025!' FIX_HEROKU_JA_PW='NouveauMDP_Ja_2025!' --app tubenplay-app

# 2. Lancer le script
heroku run "rails runner fix_heroku_users.rb" --app tubenplay-app

# 3. Nettoyer les variables
heroku config:unset FIX_HEROKU_ADMIN_PW FIX_HEROKU_USER_PW FIX_HEROKU_DRISS_PW FIX_HEROKU_JA_PW --app tubenplay-app
```

Conserve les 4 nouveaux mots de passe dans un endroit sûr (gestionnaire de mots de passe ou document sécurisé) pour toi et les utilisateurs concernés.
