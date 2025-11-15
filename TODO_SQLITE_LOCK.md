# 🔒 Problème de verrouillage SQLite - À traiter demain

## 📋 Problème rencontré

**Erreur :** `SQLite3::BusyException: database is locked`

**Contexte :** Erreur survenue lors de l'action `swipe` dans `GamesController` quand plusieurs requêtes tentent d'écrire simultanément dans la base de données.

## 🔍 Causes possibles

1. **Requêtes simultanées** : Plusieurs swipes rapides déclenchent plusieurs écritures en même temps
2. **Transaction longue** : Une transaction ouverte bloque les autres requêtes
3. **Console Rails ouverte** : Une console Rails active peut maintenir une connexion bloquante
4. **Migration en cours** : Une migration peut verrouiller la base de données
5. **Limites de SQLite** : SQLite n'est pas optimisé pour la concurrence élevée

## ✅ Solution temporaire appliquée

**Fichier modifié :** `app/controllers/games_controller.rb`

- Ajout d'un mécanisme de retry avec gestion d'exception dans la méthode `swipe`
- Si erreur "database is locked", attente progressive (0.1s, 0.2s, 0.3s) et réessai jusqu'à 3 fois
- Message d'erreur utilisateur si tous les essais échouent

## 🎯 Solutions à mettre en place demain

### 1. Activer le mode WAL (Write-Ahead Logging) pour SQLite

**Avantages :**
- Meilleure gestion de la concurrence
- Permet les lectures simultanées pendant les écritures
- Performance améliorée

**Méthode :**
```ruby
# Créer un fichier initializer : config/initializers/sqlite_wal.rb
ActiveRecord::Base.connection.execute("PRAGMA journal_mode=WAL;")
```

**Ou via migration :**
```ruby
# db/migrate/XXX_enable_wal_mode.rb
class EnableWalMode < ActiveRecord::Migration[7.0]
  def change
    execute "PRAGMA journal_mode=WAL;"
  end
end
```

### 2. Optimiser les transactions

**À vérifier :**
- S'assurer que les transactions sont courtes
- Éviter les transactions longues qui bloquent la base
- Utiliser `find_or_create_by!` avec retry si nécessaire

### 3. Vérifier les processus bloquants

**Commandes à exécuter :**
```bash
# Vérifier les processus Rails actifs
ps aux | grep -i "rails\|ruby\|sqlite" | grep -v grep

# Vérifier les connexions à la base SQLite
lsof storage/development.sqlite3
```

**Actions :**
- Fermer toutes les consoles Rails (`rails console`) ouvertes
- Redémarrer le serveur Rails si nécessaire

### 4. Augmenter le timeout SQLite (déjà fait)

**Fichier :** `config/database.yml`
- Timeout déjà configuré à 5000ms

### 5. Migration vers PostgreSQL (pour la production)

**À considérer :**
- PostgreSQL est déjà configuré pour la production dans `database.yml`
- Meilleure gestion de la concurrence pour plusieurs utilisateurs simultanés
- Nécessaire pour un déploiement en production

## 📝 Checklist pour demain

- [ ] Activer le mode WAL pour SQLite
- [ ] Vérifier et fermer les processus Rails bloquants
- [ ] Tester les swipes rapides pour valider la solution
- [ ] Optimiser les transactions dans les contrôleurs si nécessaire
- [ ] Documenter la solution dans le README ou la documentation technique
- [ ] Vérifier la configuration PostgreSQL pour la production

## 🔗 Références

- [SQLite WAL Mode](https://www.sqlite.org/wal.html)
- [Rails SQLite Configuration](https://guides.rubyonrails.org/configuring.html#configuring-a-database)
- [ActiveRecord Transactions](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html)

## 📌 Note importante

Le code avec retry est déjà en place et devrait gérer la plupart des cas temporaires. L'activation du mode WAL améliorera significativement les performances et réduira les risques de verrouillage.

