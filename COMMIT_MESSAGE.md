feat: Mise à jour utilisateurs et amélioration du branding

- Mise à jour du username de user@tubenplay.com en "Jordan"
- Ajout des avatars pour Driss, Ja et Jordan depuis app/assets/images/players/
- Mise en violet du "N" dans le titre Tube'NPlay sur toutes les pages
- Création de scripts utilitaires pour la gestion des utilisateurs et avatars

Détails:
- Username: user@tubenplay.com → Jordan
- Avatars ajoutés via Active Storage pour Driss, Ja et Jordan
- Titre Tube'NPlay avec "N" en violet (#9333ea) dans:
  * Layout principal (navigation)
  * Page d'accueil (hero section et footer)
- Scripts créés:
  * mettre_a_jour_utilisateurs.rb - Vérification et mise à jour des utilisateurs
  * ajouter_avatars.rb - Ajout d'avatars depuis app/assets/images/players/
