# 🧪 Guide de Test des Corrections Mobile

## 📋 Étapes de Test

### 1. Test Local (5-10 minutes)

#### Démarrer le serveur local
```bash
rails server
# ou
rails s
```

#### Tester rapidement
1. Ouvrir http://localhost:3000
2. Se connecter avec votre compte
3. Aller sur une playlist avec des games
4. Tester 2-3 swipes (like/dislike)
5. Vérifier qu'il n'y a pas d'erreurs dans la console Rails

**✅ Si tout fonctionne en local → Passer à la production**

### 2. Déploiement en Production

#### Vérifier les fichiers modifiés
```bash
git status
```

#### Commiter les changements
```bash
git add .
git commit -m "Fix: Corrections problèmes mobile - swipe, déconnexion, lecture vidéo"
```

#### Déployer sur Heroku
```bash
git push heroku main
# ou
git push heroku master
```

#### Vérifier les logs après déploiement
```bash
heroku logs --tail
```

### 3. Test en Production sur Mobile

#### Prérequis
- Avoir accès à https://www.tubenplay.com
- Se connecter avec : user@tubenplay.com
- Tester sur un vrai appareil mobile (pas juste le mode responsive du navigateur)

#### Scénarios de test

**Test 1 : Swipe simple**
1. Aller sur `/fr/playlists/32/games/100`
2. Swiper (like ou dislike) une vidéo
3. ✅ Vérifier : La vidéo suivante s'affiche sans déconnexion
4. ✅ Vérifier : Pas de message d'erreur

**Test 2 : Swipes multiples**
1. Swiper 5-10 vidéos consécutives
2. ✅ Vérifier : Pas de déconnexion
3. ✅ Vérifier : Les vidéos se chargent correctement
4. ✅ Vérifier : Pas d'erreur "un problème récurrent est survenu"

**Test 3 : Gestion d'erreurs**
1. Activer le mode avion pendant un swipe
2. Désactiver le mode avion
3. ✅ Vérifier : Un message d'erreur clair s'affiche
4. ✅ Vérifier : Possibilité de réessayer

**Test 4 : Session**
1. Laisser l'app ouverte 5-10 minutes sans interaction
2. Faire un swipe
3. ✅ Vérifier : Pas de déconnexion inattendue

### 4. Vérifications Techniques

#### Console du navigateur (F12 sur mobile)
- Pas d'erreurs JavaScript
- Pas d'erreurs 401 (Unauthorized)
- Les requêtes `/swipes` retournent 200 OK

#### Logs Heroku
```bash
heroku logs --tail | grep -i "swipe\|error\|session"
```

Rechercher :
- ✅ Pas d'erreurs `ActiveRecord::RecordInvalid`
- ✅ Pas d'erreurs de session expirée
- ✅ Les swipes sont bien créés avec `game_id`

## 🚨 En cas de problème

### Problème : Déconnexion persiste
1. Vérifier les logs Heroku pour les erreurs de session
2. Vérifier que `refresh_session_if_needed` est appelé
3. Vérifier les cookies de session dans le navigateur

### Problème : Vidéos ne se chargent pas
1. Vérifier que `request.base_url` est correct en production
2. Vérifier les paramètres iframe YouTube
3. Vérifier la console pour les erreurs CORS

### Problème : Erreurs JavaScript
1. Vérifier la console du navigateur
2. Vérifier que `swipe_controller.js` est bien chargé
3. Vérifier que Stimulus est bien initialisé

## ✅ Checklist finale

- [ ] Test local réussi
- [ ] Déploiement en production réussi
- [ ] Test mobile : Swipe simple OK
- [ ] Test mobile : Swipes multiples OK
- [ ] Test mobile : Pas de déconnexion
- [ ] Test mobile : Vidéos se chargent
- [ ] Pas d'erreurs dans la console
- [ ] Pas d'erreurs dans les logs Heroku

## 📞 Support

Si des problèmes persistent après déploiement :
1. Vérifier les logs Heroku en temps réel
2. Vérifier la console du navigateur mobile
3. Comparer le comportement local vs production
4. Vérifier les variables d'environnement Heroku

