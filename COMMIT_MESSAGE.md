feat: Notification persistante pour reprendre les parties en cours

- Ajout de méthodes helper pour détecter les parties non terminées
  * `current_game_in_progress` : retourne la dernière partie en cours
  * `has_game_in_progress?` : vérifie si l'utilisateur a une partie active

- Notification persistante avec bouton "Reprendre la partie"
  * Affichage automatique sur toutes les pages (sauf pages de jeu)
  * Affiche le nom de la playlist concernée
  * Bouton qui redirige directement vers la partie en cours
  * Style responsive et adaptatif

- Amélioration du layout pour garantir l'affichage plein écran
  * Layout 'shorts' forcé pour les actions show, swipe, results
  * Garantit l'affichage plein écran lors de la reprise d'une partie

L'utilisateur voit maintenant systématiquement une notification quand il
quitte une partie sans la terminer, avec un bouton pour reprendre facilement
où il s'était arrêté.
