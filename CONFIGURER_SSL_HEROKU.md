# 🔒 Guide : Configurer SSL/HTTPS sur Heroku

## 📋 Vue d'ensemble

Heroku propose deux méthodes pour configurer SSL :

1. **Automated Certificate Management (ACM)** - ✅ **Recommandé** (gratuit pour les dynos payants)
2. **Manual Certificate** - Pour les certificats externes

---

## ✅ Option 1 : Automated Certificate Management (ACM) - Recommandé

### Prérequis

- ✅ Domaine configuré sur Heroku (`www.tubenplay.com`)
- ✅ DNS configuré et propagé (CNAME pointant vers Heroku)
- ✅ Application sur un dyno payant (Hobby ou supérieur)

### Étape 1 : Vérifier le type de dyno

```bash
# Voir le type de dyno actuel
heroku ps --app tubenplay-app

# Voir les informations de l'app
heroku info --app tubenplay-app
```

**Note :** ACM nécessite un dyno payant. Si vous êtes sur un dyno gratuit (Eco), vous devrez passer à Hobby (7$/mois) ou supérieur.

### Étape 2 : Activer ACM

```bash
# Activer SSL automatique
heroku certs:auto:enable --app tubenplay-app
```

**Résultat attendu :**
```
Enabling Automatic Certificate Management... done
```

### Étape 3 : Vérifier le statut SSL

```bash
# Voir les certificats SSL
heroku certs --app tubenplay-app
```

**Résultat attendu :**
```
=== Automatic Certificate Management is enabled on tubenplay-app

Domain Name          Status
───────────────────  ────────────
www.tubenplay.com    OK
```

### Étape 4 : Attendre la génération du certificat

- ⏳ **Temps d'attente** : 5-30 minutes après activation d'ACM
- 🔄 Heroku génère automatiquement le certificat SSL via Let's Encrypt
- ✅ Une fois généré, HTTPS sera automatiquement activé

### Étape 5 : Vérifier HTTPS

```bash
# Tester l'accès HTTPS
curl -I https://www.tubenplay.com

# Ou ouvrir dans le navigateur
heroku open --app tubenplay-app
```

Vous devriez voir le cadenas 🔒 dans la barre d'adresse du navigateur.

---

## 🔧 Option 2 : Certificat Manuel (si nécessaire)

Si vous avez un certificat SSL externe ou si ACM n'est pas disponible :

### Étape 1 : Obtenir un certificat SSL

Vous pouvez obtenir un certificat gratuit via :
- **Let's Encrypt** (gratuit, renouvellement automatique)
- **Cloudflare** (si vous utilisez Cloudflare)
- **Autre fournisseur** (DigiCert, GlobalSign, etc.)

### Étape 2 : Ajouter le certificat sur Heroku

```bash
# Ajouter un certificat (remplacez par vos fichiers)
heroku certs:add server.crt server.key --app tubenplay-app

# Pour une chaîne complète (avec certificats intermédiaires)
heroku certs:add server.crt server.key --chain chain.crt --app tubenplay-app
```

### Étape 3 : Vérifier le certificat

```bash
heroku certs --app tubenplay-app
```

---

## 🔍 Vérification et Dépannage

### Vérifier le statut SSL

```bash
# Voir tous les certificats
heroku certs --app tubenplay-app

# Voir les détails d'un certificat spécifique
heroku certs:info www.tubenplay.com --app tubenplay-app
```

### Vérifier la propagation DNS

```bash
# Vérifier que le DNS pointe vers Heroku
dig www.tubenplay.com CNAME

# Attendre que le domaine soit vérifié
heroku domains:wait www.tubenplay.com --app tubenplay-app
```

### Tester HTTPS

```bash
# Test avec curl
curl -I https://www.tubenplay.com

# Test avec openssl (vérifier le certificat)
openssl s_client -connect www.tubenplay.com:443 -servername www.tubenplay.com
```

---

## ⚠️ Problèmes Courants

### Problème 1 : "ACM requires a paid dyno"

**Solution :**
- Passez à un dyno Hobby (7$/mois) ou supérieur
- Ou utilisez un certificat manuel

### Problème 2 : "Certificate pending" ou "DNS not verified"

**Solutions :**
1. Vérifiez que le DNS est correctement configuré :
   ```bash
   dig www.tubenplay.com CNAME
   ```
2. Attendez la propagation DNS (peut prendre jusqu'à 48h)
3. Vérifiez que le CNAME pointe vers le bon DNS Target Heroku

### Problème 3 : "Certificate expired"

**Solution :**
- ACM renouvelle automatiquement les certificats
- Si vous utilisez un certificat manuel, renouvelez-le et réinstallez-le

### Problème 4 : Erreur "SSL certificate problem"

**Solutions :**
1. Vérifiez que le domaine est bien configuré :
   ```bash
   heroku domains --app tubenplay-app
   ```
2. Vérifiez le statut SSL :
   ```bash
   heroku certs --app tubenplay-app
   ```
3. Redémarrez l'application :
   ```bash
   heroku restart --app tubenplay-app
   ```

---

## 📝 Commandes Utiles

```bash
# Activer ACM
heroku certs:auto:enable --app tubenplay-app

# Désactiver ACM
heroku certs:auto:disable --app tubenplay-app

# Voir les certificats
heroku certs --app tubenplay-app

# Voir les détails d'un certificat
heroku certs:info www.tubenplay.com --app tubenplay-app

# Mettre à jour un certificat manuel
heroku certs:update server.crt server.key --app tubenplay-app

# Supprimer un certificat
heroku certs:remove www.tubenplay.com --app tubenplay-app

# Vérifier les domaines
heroku domains --app tubenplay-app

# Attendre la vérification DNS
heroku domains:wait www.tubenplay.com --app tubenplay-app
```

---

## ✅ Checklist de Configuration SSL

- [ ] Domaine configuré sur Heroku (`www.tubenplay.com`)
- [ ] DNS configuré dans Namecheap (CNAME vers Heroku)
- [ ] DNS propagé (vérifié avec `dig` ou `nslookup`)
- [ ] Dyno payant activé (si utilisation d'ACM)
- [ ] ACM activé : `heroku certs:auto:enable --app tubenplay-app`
- [ ] Certificat généré (vérifié avec `heroku certs`)
- [ ] HTTPS accessible : `https://www.tubenplay.com`
- [ ] Cadenas SSL visible dans le navigateur 🔒

---

## 🎉 Résultat Final

Une fois SSL configuré, votre application sera :

- ✅ Accessible via **HTTPS** : `https://www.tubenplay.com`
- ✅ Sécurisée avec un **certificat SSL valide**
- ✅ **Renouvellement automatique** (si ACM activé)
- ✅ **Conforme aux standards de sécurité** modernes

---

## 📚 Ressources

- [Documentation Heroku SSL](https://devcenter.heroku.com/articles/ssl)
- [Heroku ACM Documentation](https://devcenter.heroku.com/articles/automated-certificate-management)
- [Let's Encrypt](https://letsencrypt.org/)

---

**Une fois SSL configuré, votre site sera accessible en toute sécurité sur https://www.tubenplay.com ! 🔒**

