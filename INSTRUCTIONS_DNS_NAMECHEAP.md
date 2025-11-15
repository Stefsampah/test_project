# 📝 Instructions : Ajouter les Enregistrements DNS dans Namecheap

## 🎯 Enregistrements à Ajouter

Voici exactement ce que vous devez ajouter dans Namecheap pour `tubenplay.com` :

---

## 📋 Étape 1 : Se Connecter à Namecheap

1. Allez sur **https://www.namecheap.com**
2. Connectez-vous à votre compte
3. Cliquez sur **"Domain List"** (menu de gauche)
4. Trouvez **`tubenplay.com`**
5. Cliquez sur **"Manage"** à côté du domaine
6. Allez dans l'onglet **"Advanced DNS"** (en haut de la page)

---

## 📋 Étape 2 : Ajouter les Enregistrements CNAME

### CNAME 1 : url8623

1. Cliquez sur **"Add New Record"** (bouton +)
2. Sélectionnez **"CNAME Record"**
3. Remplissez :
   - **Host** : `url8623`
   - **Value** : `sendgrid.net`
   - **TTL** : Automatic (ou 30 min)
4. Cliquez sur le **checkmark (✓)** pour sauvegarder

### CNAME 2 : 57286935

1. Cliquez sur **"Add New Record"**
2. Sélectionnez **"CNAME Record"**
3. Remplissez :
   - **Host** : `57286935`
   - **Value** : `sendgrid.net`
   - **TTL** : Automatic
4. Cliquez sur le **checkmark (✓)** pour sauvegarder

### CNAME 3 : em3875

1. Cliquez sur **"Add New Record"**
2. Sélectionnez **"CNAME Record"**
3. Remplissez :
   - **Host** : `em3875`
   - **Value** : `u57286935.wl186.sendgrid.net`
   - **TTL** : Automatic
4. Cliquez sur le **checkmark (✓)** pour sauvegarder

### CNAME 4 : s1._domainkey

1. Cliquez sur **"Add New Record"**
2. Sélectionnez **"CNAME Record"**
3. Remplissez :
   - **Host** : `s1._domainkey`
   - **Value** : `s1.domainkey.u57286935.wl186.sendgrid.net`
   - **TTL** : Automatic
4. Cliquez sur le **checkmark (✓)** pour sauvegarder

### CNAME 5 : s2._domainkey

1. Cliquez sur **"Add New Record"**
2. Sélectionnez **"CNAME Record"**
3. Remplissez :
   - **Host** : `s2._domainkey`
   - **Value** : `s2.domainkey.u57286935.wl186.sendgrid.net`
   - **TTL** : Automatic
4. Cliquez sur le **checkmark (✓)** pour sauvegarder

---

## 📋 Étape 3 : Ajouter l'Enregistrement TXT

### TXT : _dmarc

1. Cliquez sur **"Add New Record"**
2. Sélectionnez **"TXT Record"**
3. Remplissez :
   - **Host** : `_dmarc`
   - **Value** : `v=DMARC1; p=none;`
   - **TTL** : Automatic
4. Cliquez sur le **checkmark (✓)** pour sauvegarder

---

## ✅ Résumé des 6 Enregistrements

| Type | Host | Value |
|------|------|-------|
| CNAME | `url8623` | `sendgrid.net` |
| CNAME | `57286935` | `sendgrid.net` |
| CNAME | `em3875` | `u57286935.wl186.sendgrid.net` |
| CNAME | `s1._domainkey` | `s1.domainkey.u57286935.wl186.sendgrid.net` |
| CNAME | `s2._domainkey` | `s2.domainkey.u57286935.wl186.sendgrid.net` |
| TXT | `_dmarc` | `v=DMARC1; p=none;` |

---

## ⚠️ Points Importants

### Pour le Host :
- ✅ **Ne mettez PAS** `tubenplay.com`
- ✅ Mettez **seulement** la partie avant (ex: `url8623`, pas `url8623.tubenplay.com`)
- ✅ Pour `_dmarc.tubenplay.com`, mettez juste `_dmarc`

### Pour la Value :
- ✅ **Copiez exactement** ce que SendGrid vous a donné
- ✅ **Pas d'espaces en trop**
- ✅ **Respectez les majuscules/minuscules**

### Exemple d'Erreur à Éviter :
- ❌ Host : `url8623.tubenplay.com` (trop long)
- ✅ Host : `url8623` (correct)

---

## 📋 Checklist

Après avoir ajouté tous les enregistrements, vérifiez :

- [ ] 5 enregistrements CNAME ajoutés
- [ ] 1 enregistrement TXT ajouté
- [ ] Tous les Host sont corrects (sans `.tubenplay.com`)
- [ ] Toutes les Values sont exactement comme SendGrid les a données
- [ ] Tous les enregistrements sont sauvegardés (checkmark vert)

---

## ⏰ Après l'Ajout

1. **Attendez 15-30 minutes** pour la propagation DNS
2. **Retournez dans SendGrid**
3. Allez dans **Settings** → **Sender Authentication** → **Domain Authentication**
4. Cliquez sur votre domaine `tubenplay.com`
5. SendGrid vérifiera automatiquement les enregistrements

**Statut attendu :** ✅ **Verified** (peut prendre quelques minutes)

---

## 🆘 Si Ça Ne Fonctionne Pas

### Vérifications :
1. ✅ Tous les 6 enregistrements sont bien ajoutés ?
2. ✅ Les Host sont corrects (sans `.tubenplay.com`) ?
3. ✅ Les Values sont exactement comme SendGrid les a données ?
4. ✅ Vous avez attendu au moins 15-30 minutes ?

### Si le statut est toujours "Pending" :
- Attendez encore un peu (la propagation peut prendre jusqu'à 24h, mais généralement c'est rapide)
- Vérifiez un par un chaque enregistrement dans Namecheap
- Comparez exactement avec ce que SendGrid vous a donné

---

## 💡 Astuce

**Prenez votre temps !** Vérifiez chaque enregistrement deux fois avant de sauvegarder.

**Si vous avez un doute sur un enregistrement, dites-moi et je vous aiderai !** 🚀

