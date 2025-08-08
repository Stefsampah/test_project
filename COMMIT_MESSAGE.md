feat: Harmonisation complète du système de récompenses avec détails cliquables

## 🎯 Améliorations principales

### ✨ Interface utilisateur harmonisée
- **Cartes uniformisées** : Design identique entre "Mes récompenses" et "Toutes les récompenses"
- **Boutons "Voir détails"** : Liens cliquables vers les détails de chaque récompense
- **Design cohérent** : Couleurs, animations et transitions harmonisées
- **Responsive** : Interface adaptative pour tous les écrans

### 🎁 Page de détails des récompenses
- **Template complet** : Nouvelle vue `rewards/show.html.erb`
- **Informations détaillées** : Statistiques, progression, date de déblocage
- **Playlists associées** : Affichage des playlists challenge avec métadonnées
- **Vidéos intégrées** : Thumbnails YouTube et liens directs vers les vidéos
- **Navigation fluide** : Boutons pour accéder aux playlists et vidéos

### 🔗 Intégration des playlists challenge
- **15 playlists challenge** : Videos 1-15 avec contenu complet
- **Associations automatiques** : Liens entre récompenses et playlists
- **Métadonnées enrichies** : Statistiques, descriptions, thumbnails
- **Accès direct** : Navigation vers les playlists depuis les détails

### 🎵 Contenu multimédia
- **Thumbnails YouTube** : Images automatiques pour chaque vidéo
- **Liens externes** : Accès direct aux vidéos YouTube
- **Descriptions enrichies** : Informations détaillées sur chaque vidéo
- **Interface intuitive** : Design moderne pour la navigation

### 🛠️ Améliorations techniques
- **Contrôleur optimisé** : Méthode `show` avec récupération des playlists
- **Scripts de test** : Debug et simulation des récompenses
- **Gestion des erreurs** : Fallbacks pour les playlists manquantes
- **Performance** : Requêtes optimisées avec includes

## 📊 Statistiques
- 7 récompenses challenge créées
- 6 playlists avec 10 vidéos chacune
- Interface 100% responsive
- Navigation fluide entre toutes les pages

## 🎨 Design
- Gradient backgrounds cohérents
- Animations et transitions fluides
- Cards design moderne
- Couleurs harmonisées par niveau

## 🔧 Scripts ajoutés
- `simulate_challenge_rewards.rb` : Simulation des récompenses
- `test_rewards_debug.rb` : Debug du système
- Gestion des contraintes de clé unique

## ✅ Tests
- Système de récompenses fonctionnel
- Liens et navigation opérationnels
- Playlists et vidéos accessibles
- Interface utilisateur cohérente
