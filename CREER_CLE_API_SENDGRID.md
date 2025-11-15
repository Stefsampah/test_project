# 🔑 Guide : Créer la Clé API SendGrid

## 🎯 Étapes Détaillées

### Étape 1 : Accéder aux API Keys

1. **Connectez-vous à SendGrid** : https://app.sendgrid.com
2. Dans le menu en haut à droite, cliquez sur **"Settings"** (icône d'engrenage ⚙️)
3. Dans le menu de gauche, cliquez sur **"API Keys"**

### Étape 2 : Créer une Nouvelle Clé API

1. Cliquez sur le bouton **"Create API Key"** (en haut à droite, bouton bleu)
2. Une fenêtre s'ouvre pour configurer la clé

### Étape 3 : Configurer la Clé API

#### 3.1 Nom de la Clé

**Entrez :** `TubeNPlay Production` ou `Heroku App`

(Ce nom vous aidera à identifier la clé plus tard)

#### 3.2 Permissions

Vous avez 2 options :

**Option A : Full Access (Plus Simple)**
- Cliquez sur **"Full Access"**
- ✅ Plus simple, tout est autorisé
- ⚠️ Moins sécurisé (mais OK pour commencer)

**Option B : Restricted Access (Plus Sécurisé)**
- Cliquez sur **"Restricted Access"**
- Dans la liste, cochez seulement **"Mail Send"**
- ✅ Plus sécurisé, seulement l'envoi d'emails
- ✅ Recommandé pour la production

**Ma recommandation :** Choisissez **"Restricted Access"** avec seulement **"Mail Send"** coché.

#### 3.3 Créer la Clé

1. Cliquez sur **"Create & View"** (en bas de la fenêtre)

### Étape 4 : ⚠️ IMPORTANT - Copier la Clé API

**⚠️ ATTENTION CRITIQUE :**

SendGrid affiche la clé API **UNE SEULE FOIS** ! Après avoir fermé cette fenêtre, vous ne pourrez plus la voir.

**La clé ressemble à :**
```
SG.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Actions immédiates :**
1. ✅ **Copiez la clé** (Ctrl+C ou Cmd+C)
2. ✅ **Collez-la dans un fichier texte** temporairement
3. ✅ **Notez-la dans un endroit sûr** (vous en aurez besoin pour Heroku)

**⚠️ Ne fermez pas la fenêtre avant d'avoir copié la clé !**

---

## 📋 Après Avoir Créé la Clé

### Vérification

1. Vous devriez voir la clé dans la liste des API Keys
2. Le nom que vous avez donné apparaît
3. La clé elle-même est masquée (normal, pour la sécurité)

### Si Vous Avez Perdu la Clé

**Pas de panique !** Vous pouvez :
1. Supprimer l'ancienne clé
2. En créer une nouvelle
3. Mettre à jour la configuration Heroku avec la nouvelle clé

---

## ✅ Checklist

- [ ] Je suis connecté à SendGrid
- [ ] J'ai accédé à Settings → API Keys
- [ ] J'ai cliqué sur "Create API Key"
- [ ] J'ai donné un nom à la clé
- [ ] J'ai choisi les permissions (Full Access ou Restricted avec Mail Send)
- [ ] J'ai cliqué sur "Create & View"
- [ ] **J'ai copié la clé API immédiatement**
- [ ] J'ai noté la clé dans un endroit sûr

---

## 🎯 Prochaine Étape

Une fois la clé API créée et copiée :

1. ✅ Vous pourrez configurer Heroku avec cette clé
2. ✅ L'envoi d'emails fonctionnera

**Dites-moi quand vous avez créé et copié la clé API, et je vous guiderai pour configurer Heroku !** 🚀

