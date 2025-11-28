# 🚀 Guide Final : PayPal Live + DNS Heroku

Ce guide vous accompagne pour configurer PayPal en mode live et ajouter votre domaine personnalisé sur Heroku.

---

## 📋 Partie 1 : Configurer PayPal en Mode Live

### Étape 1.1 : Obtenir les Clés API PayPal Live

1. **Aller sur https://developer.paypal.com**
2. **Se connecter** avec votre compte PayPal Business
3. **Dashboard** → **My Apps & Credentials**
4. Cliquer sur l'onglet **"Live"** (pas Sandbox)
5. **Créer une nouvelle app** ou utiliser une existante :
   - Nom : "Tube'NPlay Production"
   - Cliquer sur **"Create App"**
6. **Copier les clés** :
   - **Client ID** : Commence par `Ae...` ou `AY...`
   - **Secret** : Cliquer sur **"Show"** puis copier (⚠️ affiché une seule fois !)

### Étape 1.2 : Configurer sur Heroku

#### Option A : Utiliser le Script Automatique

```bash
# Rendre le script exécutable
chmod +x configure_paypal_live.sh

# Exécuter le script
./configure_paypal_live.sh
```

Le script vous demandera :
- PayPal Client ID (Live)
- PayPal Client Secret (Live)

#### Option B : Configuration Manuelle

```bash
# Remplacer VOTRE_CLIENT_ID et VOTRE_SECRET par vos vraies clés
heroku config:set PAYPAL_CLIENT_ID=VOTRE_CLIENT_ID --app tubenplay-app
heroku config:set PAYPAL_CLIENT_SECRET=VOTRE_SECRET --app tubenplay-app
heroku config:set PAYPAL_MODE=live --app tubenplay-app
```

### Étape 1.3 : Vérifier la Configuration

```bash
# Voir les variables PayPal configurées
heroku config --app tubenplay-app | grep PAYPAL

# Redémarrer l'application
heroku restart --app tubenplay-app

# Vérifier les logs
heroku logs --tail --app tubenplay-app
```

Vous devriez voir dans les logs :
```
✅ PayPal configuré en mode live
```

### ⚠️ Important : Mode Live

- **Les paiements seront RÉELS** et facturés aux utilisateurs
- **Testez d'abord avec un petit montant** pour vérifier que tout fonctionne
- **Vérifiez que les montants sont corrects** avant de mettre en production

---

## 📋 Partie 2 : Configurer le DNS sur Heroku

### Étape 2.1 : Ajouter le Domaine sur Heroku

#### Option A : Utiliser le Script Automatique

```bash
# Rendre le script exécutable
chmod +x configure_dns_heroku.sh

# Exécuter le script
./configure_dns_heroku.sh

# Ou avec le domaine en argument
./configure_dns_heroku.sh www.tubenplay.com
```

#### Option B : Configuration Manuelle

```bash
# Ajouter le domaine www
heroku domains:add www.tubenplay.com --app tubenplay-app

# (Optionnel) Ajouter le domaine racine
heroku domains:add tubenplay.com --app tubenplay-app
```

### Étape 2.2 : Voir les Informations DNS

```bash
# Voir tous les domaines configurés
heroku domains --app tubenplay-app
```

Heroku vous donnera quelque chose comme :
```
=== tubenplay-app Heroku Domain
tubenplay-app.herokuapp.com

=== tubenplay-app Custom Domains
Domain Name          DNS Record Type  DNS Target
───────────────────  ───────────────  ──────────────────────────────
www.tubenplay.com    CNAME            tubenplay-app.herokuapp.com
tubenplay.com        ALIAS or A       (IP sera fournie)
```

### Étape 2.3 : Configurer le DNS chez Votre Registrar

#### Pour www.tubenplay.com (CNAME)

1. **Connectez-vous** à votre registrar (Namecheap, GoDaddy, etc.)
2. **Allez dans la gestion DNS** de votre domaine
3. **Ajoutez un enregistrement CNAME** :
   - **Type** : CNAME
   - **Host/Name** : `www`
   - **Value/Target** : `tubenplay-app.herokuapp.com`
   - **TTL** : 3600 (ou Automatic)

#### Pour tubenplay.com (Domaine Racine)

**Option A : ALIAS/ANAME (Recommandé si disponible)**

- **Type** : ALIAS ou ANAME
- **Host** : `@` ou laisser vide
- **Value** : `tubenplay-app.herokuapp.com`

**Option B : Enregistrement A**

Heroku vous fournira une IP après l'ajout du domaine. Utilisez-la :
- **Type** : A
- **Host** : `@` ou laisser vide
- **Value** : `75.101.145.87` (exemple, utilisez l'IP fournie par Heroku)

### Étape 2.4 : Activer SSL Automatique

```bash
# Activer SSL automatique (gratuit)
heroku certs:auto:enable --app tubenplay-app

# Vérifier le statut SSL
heroku certs --app tubenplay-app
```

**Note** : Le certificat SSL sera généré automatiquement une fois le DNS configuré et propagé. Cela peut prendre quelques minutes à quelques heures.

### Étape 2.5 : Vérifier la Propagation DNS

```bash
# Vérifier depuis votre machine
dig www.tubenplay.com
nslookup www.tubenplay.com

# Ou utiliser un outil en ligne
# https://www.whatsmydns.net/
```

### Étape 2.6 : Tester le Domaine

Une fois le DNS propagé (généralement 5-30 minutes) :

1. **Visitez** `https://www.tubenplay.com`
2. **Vérifiez** que le certificat SSL est valide (cadenas vert)
3. **Vérifiez** que l'application fonctionne correctement

---

## ✅ Checklist Finale

### PayPal Live
- [ ] Clés API Live obtenues depuis PayPal Developer
- [ ] Variables d'environnement configurées sur Heroku
- [ ] `PAYPAL_MODE=live` configuré
- [ ] Application redémarrée
- [ ] Logs vérifiés (mode live confirmé)
- [ ] Test avec un petit montant effectué

### DNS Heroku
- [ ] Domaine ajouté sur Heroku (`heroku domains:add`)
- [ ] Enregistrement CNAME configuré chez le registrar (pour www)
- [ ] Enregistrement ALIAS/A configuré chez le registrar (pour domaine racine)
- [ ] SSL automatique activé (`heroku certs:auto:enable`)
- [ ] DNS propagé (vérifié avec `dig` ou outil en ligne)
- [ ] Site accessible via le domaine personnalisé
- [ ] Certificat SSL valide (cadenas vert)

---

## 🆘 En cas de Problème

### PayPal

**Problème** : Les paiements ne fonctionnent pas
- Vérifiez que `PAYPAL_MODE=live` est bien configuré
- Vérifiez que les clés sont correctes (pas de clés Sandbox)
- Consultez les logs : `heroku logs --tail --app tubenplay-app`

### DNS

**Problème** : Le domaine ne fonctionne pas
- Vérifiez la propagation DNS : `dig www.tubenplay.com`
- Vérifiez que le CNAME pointe vers `tubenplay-app.herokuapp.com`
- Attendez jusqu'à 48h pour la propagation complète
- Vérifiez les domaines sur Heroku : `heroku domains --app tubenplay-app`

**Problème** : SSL non généré
- Attendez que le DNS soit propagé
- Vérifiez : `heroku certs --app tubenplay-app`
- Réessayez : `heroku certs:auto:enable --app tubenplay-app`

---

## 📚 Commandes Utiles

```bash
# Voir toutes les variables d'environnement
heroku config --app tubenplay-app

# Voir les domaines
heroku domains --app tubenplay-app

# Voir les certificats SSL
heroku certs --app tubenplay-app

# Redémarrer l'application
heroku restart --app tubenplay-app

# Voir les logs
heroku logs --tail --app tubenplay-app

# Console Rails en production
heroku run rails console --app tubenplay-app
```

---

## 🎉 Félicitations !

Une fois ces deux configurations terminées, votre application sera :
- ✅ Prête à accepter des **paiements réels** via PayPal
- ✅ Accessible via votre **domaine personnalisé** (www.tubenplay.com)
- ✅ Sécurisée avec **SSL/HTTPS** automatique

