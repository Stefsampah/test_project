# 📊 Guide : Monitoring et Analyse du Trafic

## 🎯 Options de Monitoring

### 1. Google Analytics 4 (GA4) - ✅ Recommandé

**Avantages :**
- ✅ Gratuit
- ✅ Très complet (trafic, comportement, conversions, etc.)
- ✅ Intégration facile
- ✅ Tableaux de bord personnalisables
- ✅ Suivi en temps réel

**Ce que vous pouvez suivre :**
- Nombre de visiteurs
- Pages les plus visitées
- Source du trafic (Google, réseaux sociaux, etc.)
- Géolocalisation des visiteurs
- Appareils utilisés (mobile, desktop, tablette)
- Temps passé sur le site
- Taux de rebond
- Conversions (inscriptions, achats, etc.)

---

## 📋 Configuration Google Analytics 4

### Étape 1 : Créer un compte Google Analytics

1. Allez sur **https://analytics.google.com/**
2. Connectez-vous avec votre compte Google
3. Cliquez sur **"Commencer la mesure"**
4. Créez un compte (ex: "Tube'NPlay")
5. Créez une propriété :
   - **Nom** : `www.tubenplay.com`
   - **Fuseau horaire** : Europe/Paris
   - **Devise** : EUR
6. Choisissez **"Web"** comme plateforme
7. Entrez l'URL : `https://www.tubenplay.com`
8. Configurez les objectifs (optionnel)

### Étape 2 : Obtenir l'ID de mesure

Une fois la propriété créée, Google vous donnera un **ID de mesure** (format : `G-XXXXXXXXXX`)

**Exemple :** `G-ABC123XYZ456`

### Étape 3 : Ajouter le code de suivi dans l'application

Le code de suivi sera ajouté dans `app/views/layouts/application.html.erb` dans la section `<head>`.

---

## 🔧 Intégration dans Rails

### Option 1 : Variable d'environnement (Recommandé)

1. **Ajouter la variable sur Heroku :**
   ```bash
   heroku config:set GA_MEASUREMENT_ID=G-XXXXXXXXXX --app tubenplay-app
   ```

2. **Ajouter le code dans le layout** (déjà fait dans le guide)

### Option 2 : Configuration directe

Ajouter directement l'ID dans le code (moins flexible)

---

## 📈 Autres Outils de Monitoring

### 2. Google Search Console (Déjà configuré ✅)

**Ce que vous pouvez suivre :**
- Requêtes de recherche (mots-clés)
- Pages indexées
- Performances dans les résultats Google
- Erreurs d'indexation
- Liens externes

**Accès :** https://search.google.com/search-console

### 3. Heroku Metrics

**Ce que vous pouvez suivre :**
- Performance de l'application
- Temps de réponse
- Utilisation de la mémoire
- CPU
- Erreurs serveur

**Accès :** Dashboard Heroku → Métriques

### 4. Plausible Analytics (Alternative à GA)

**Avantages :**
- ✅ Respect de la vie privée (RGPD)
- ✅ Interface simple
- ✅ Pas de cookies
- ⚠️ Payant (9€/mois)

**Site :** https://plausible.io/

---

## 🎯 Événements Personnalisés à Suivre

Pour Tube'NPlay, vous pouvez suivre :

1. **Inscriptions** : Quand un utilisateur s'inscrit
2. **Connexions** : Quand un utilisateur se connecte
3. **Lancement de jeu** : Quand un utilisateur commence une playlist
4. **Achats** : Quand un utilisateur achète des points ou un abonnement VIP
5. **Déblocage de playlist** : Quand une playlist premium est débloquée
6. **Gain de badge** : Quand un utilisateur gagne un badge

---

## 📊 Tableaux de Bord Recommandés

### Dashboard Principal
- Visiteurs uniques (jour/semaine/mois)
- Pages les plus visitées
- Source du trafic
- Taux de conversion (inscriptions)

### Dashboard E-commerce
- Revenus
- Taux de conversion des achats
- Panier moyen
- Produits les plus vendus (points, abonnements)

### Dashboard Engagement
- Temps moyen sur le site
- Nombre de pages par session
- Taux de rebond
- Playlists les plus jouées

---

## 🔍 Commandes Utiles

```bash
# Voir les métriques Heroku
heroku ps --app tubenplay-app

# Voir les logs en temps réel
heroku logs --tail --app tubenplay-app

# Voir les erreurs
heroku logs --tail --app tubenplay-app | grep ERROR
```

---

## 📚 Ressources

- [Google Analytics 4](https://analytics.google.com/)
- [Documentation GA4](https://developers.google.com/analytics/devguides/collection/ga4)
- [Google Search Console](https://search.google.com/search-console)
- [Heroku Metrics](https://devcenter.heroku.com/articles/metrics)

---

**Une fois Google Analytics configuré, vous aurez une vue complète du trafic et du comportement des utilisateurs sur votre site ! 📊**

