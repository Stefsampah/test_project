# 🌐 Guide : Configurer www.tubenplay.com avec Heroku

## ✅ Étape 1 : Domaine ajouté sur Heroku

Le domaine `www.tubenplay.com` a été ajouté avec succès sur Heroku.

**DNS Target Heroku :** `arcane-chimpanzee-mii582ed4mk97keo447ss6r3.herokudns.com`

---

## 📋 Étape 2 : Configurer le DNS dans Namecheap

### 2.1 Accéder aux DNS de Namecheap

1. Allez sur **https://www.namecheap.com**
2. Connectez-vous à votre compte
3. Allez dans **Domain List**
4. Cliquez sur **Manage** à côté de `tubenplay.com`

### 2.2 Ajouter l'enregistrement CNAME pour www

1. Allez dans l'onglet **Advanced DNS**
2. Dans la section **Host Records**, trouvez ou ajoutez un enregistrement pour `www`

**Configuration :**

| Type | Host | Value | TTL |
|------|------|-------|-----|
| CNAME | `www` | `arcane-chimpanzee-mii582ed4mk97keo447ss6r3.herokudns.com.` | Automatic (ou 30 min) |

**⚠️ Important :**
- **Host** : `www` (sans le domaine)
- **Value** : `arcane-chimpanzee-mii582ed4mk97keo447ss6r3.herokudns.com.` (avec le point à la fin)
- **Type** : `CNAME`

### 2.3 Vérifier les enregistrements existants

Si vous avez déjà un enregistrement `www` :
- **Modifiez-le** pour pointer vers le DNS Target Heroku
- **Supprimez l'ancien** si nécessaire

---

## 📋 Étape 3 : Vérifier la configuration

### 3.1 Attendre la propagation DNS

La propagation DNS peut prendre de **quelques minutes à 48 heures**. En général, c'est actif dans les 30 minutes.

### 3.2 Vérifier avec Heroku

```bash
heroku domains:wait www.tubenplay.com --app tubenplay-app
```

Cette commande attend que le domaine soit vérifié par Heroku.

### 3.3 Tester l'accès

Une fois la propagation terminée, vous devriez pouvoir accéder à :
- **https://www.tubenplay.com**

---

## 🔍 Vérification DNS

Vous pouvez vérifier si le DNS est correctement configuré avec :

```bash
# Vérifier le CNAME
dig www.tubenplay.com CNAME

# Ou avec nslookup
nslookup www.tubenplay.com
```

Vous devriez voir pointer vers `arcane-chimpanzee-mii582ed4mk97keo447ss6r3.herokudns.com`

---

## ⚙️ Configuration SSL (Automatique)

Heroku configure automatiquement le certificat SSL pour votre domaine personnalisé. Une fois le DNS configuré, HTTPS sera automatiquement activé.

---

## 📝 Résumé

1. ✅ **Domaine ajouté sur Heroku** : `www.tubenplay.com`
2. ⏳ **DNS à configurer dans Namecheap** :
   - Type : `CNAME`
   - Host : `www`
   - Value : `arcane-chimpanzee-mii582ed4mk97keo447ss6r3.herokudns.com.`
3. ⏳ **Attendre la propagation DNS** (30 min - 48h)
4. ✅ **HTTPS automatique** une fois configuré

---

## 🆘 En cas de problème

- **Le domaine ne fonctionne pas** : Vérifiez que le CNAME est correct dans Namecheap
- **Erreur SSL** : Attendez quelques minutes, Heroku configure SSL automatiquement
- **Timeout** : Vérifiez que le DNS Target est correct

---

**Une fois le DNS configuré dans Namecheap, votre application sera accessible sur https://www.tubenplay.com !**

