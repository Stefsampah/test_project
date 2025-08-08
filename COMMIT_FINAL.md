fix: Correction de l'affichage des boutons "Voir détails" sur la page "Mes récompenses"

## 🐛 Problème résolu
- Les boutons "Voir détails" ne s'affichaient pas sur les cartes de récompenses débloquées
- Le contrôleur récupérait toutes les récompenses (débloquées et verrouillées) au lieu de filtrer uniquement les débloquées

## 🔧 Correction apportée
- Modification du contrôleur `rewards_controller.rb` pour filtrer uniquement les récompenses débloquées
- Ajout du scope `.unlocked` aux requêtes de récompenses par niveau

### Avant :
```ruby
@challenge_rewards = @rewards.where(reward_type: 'challenge')
@exclusif_rewards = @rewards.where(reward_type: 'exclusif')
@premium_rewards = @rewards.where(reward_type: 'premium')
@ultime_rewards = @rewards.where(reward_type: 'ultime')
```

### Après :
```ruby
@challenge_rewards = @rewards.where(reward_type: 'challenge').unlocked
@exclusif_rewards = @rewards.where(reward_type: 'exclusif').unlocked
@premium_rewards = @rewards.where(reward_type: 'premium').unlocked
@ultime_rewards = @rewards.where(reward_type: 'ultime').unlocked
```

## ✅ Résultat
- Boutons "Voir détails" maintenant visibles sur toutes les récompenses débloquées
- Navigation complète fonctionnelle vers les pages de détails
- Accès aux playlists et vidéos depuis les détails des récompenses
- Interface utilisateur 100% opérationnelle

## 🎯 Fonctionnalités confirmées
- ✅ Cartes harmonisées entre "Mes récompenses" et "Toutes les récompenses"
- ✅ Boutons "Voir détails" cliquables sur les récompenses débloquées
- ✅ Page de détails complète avec playlists associées
- ✅ Navigation fluide vers les playlists et vidéos
- ✅ Interface responsive et design moderne
