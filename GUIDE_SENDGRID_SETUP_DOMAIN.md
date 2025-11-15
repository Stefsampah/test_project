for# 📧 Guide : Configuration du Domaine dans SendGrid

## 🎯 Écran "Set Up Sending" - Que Faire ?

### 1. Domain

**Entrez :** `tubenplay.com`

**Pas de https://** - Entrez juste le domaine : `tubenplay.com`

✅ **Cochez cette case** - C'est important pour que les emails partent de `noreply@tubenplay.com` au lieu de `noreply@sendgrid.net`

---

### 2. Brand the link for this domain ?

**Question :** Voulez-vous "brander" les liens pour ce domaine ?

#### Qu'est-ce que c'est ?

- **Oui** : Les liens de tracking dans les emails utiliseront `tubenplay.com` au lieu de `sendgrid.net`
  - Exemple : `https://tubenplay.com/click/...` au lieu de `https://sendgrid.net/click/...`
  - ✅ Plus professionnel
  - ✅ Meilleure délivrabilité
  - ⚠️ Nécessite une configuration DNS supplémentaire

- **Non** : Les liens utiliseront `sendgrid.net`
  - ✅ Plus simple, pas de configuration DNS supplémentaire
  - ❌ Moins professionnel

#### Recommandation

**Pour commencer :** Choisissez **"No"** (Non)

**Pourquoi ?**
- Plus simple à configurer
- Vous pourrez l'activer plus tard si besoin
- Ça fonctionne très bien comme ça

**Plus tard :** Vous pourrez activer le branding des liens dans SendGrid → Settings → Sender Authentication

---

## 📋 Étapes à Suivre

### Sur l'écran SendGrid :

1. **Domain** : Entrez `tubenplay.com` (sans https://)
2. **Brand the link** : Choisissez **"No"** (pour simplifier)
3. Cliquez sur **"Next"** ou **"Continue"**

### Ensuite, SendGrid vous demandera de configurer le DNS

SendGrid va vous donner des enregistrements DNS à ajouter dans Namecheap.

**Ne vous inquiétez pas !** Même si vous ne configurez pas le DNS maintenant, SendGrid fonctionnera quand même. Vous pourrez le faire plus tard.

---

## ⚠️ Important

### Si vous choisissez "No" pour le branding :

✅ **Ça fonctionne parfaitement** - Les emails partiront quand même de `noreply@tubenplay.com`
✅ **Plus simple** - Pas besoin de configurer le DNS maintenant
✅ **Vous pourrez l'activer plus tard** si vous voulez

### Si vous choisissez "Yes" :

⚠️ **Nécessite une configuration DNS** dans Namecheap
⚠️ **Plus complexe** - Il faut ajouter des enregistrements CNAME
✅ **Plus professionnel** - Les liens utiliseront votre domaine

---

## 🎯 Ma Recommandation

**Pour l'instant :**
1. Domain : `tubenplay.com`
2. Brand the link : **No**
3. Continuez avec la configuration

**Plus tard** (optionnel) :
- Vous pourrez activer le branding des liens dans SendGrid
- Suivez les instructions DNS que SendGrid vous donnera

---

## 📝 Résumé

**Sur l'écran SendGrid :**
- ✅ Domain : `tubenplay.com`
- ✅ Brand the link : **No** (recommandé pour commencer)
- ✅ Cliquez sur "Next"

**C'est tout !** Continuez avec la configuration SendGrid.

