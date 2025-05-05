// Service de gestion des badges
window.badgeService = (function() {
  // Données des badges
  const badges = [
    // Badges Competitor
    {
      id: 1,
      name: "Bronze Competitor",
      type: "competitor",
      level: "bronze",
      points_required: 100,
      description: "Vous commencez à vous faire remarquer dans les compétitions",
      reward_type: "standard",
      reward_description: "Accès à une playlist exclusive",
      reward_image: "/assets/badges/dropmixpop.webp"
    },
    {
      id: 2,
      name: "Silver Competitor",
      type: "competitor",
      level: "silver",
      points_required: 500,
      description: "Vous êtes un compétiteur redoutable",
      reward_type: "premium",
      reward_description: "Accès à des playlists premium",
      reward_image: "/assets/badges/pandora-playlist-collage.webp"
    },
    {
      id: 3,
      name: "Gold Competitor",
      type: "competitor",
      level: "gold",
      points_required: 1000,
      description: "Vous êtes un champion incontesté",
      reward_type: "premium",
      reward_description: "Accès VIP à toutes les playlists",
      reward_image: "/assets/badges/VIP-gold.jpg"
    },
    
    // Badges Engager
    {
      id: 4,
      name: "Bronze Engager",
      type: "engager",
      level: "bronze",
      points_required: 50,
      description: "Vous commencez à vous engager activement",
      reward_type: "standard",
      reward_description: "Accès à des statistiques détaillées"
    },
    {
      id: 5,
      name: "Silver Engager",
      type: "engager",
      level: "silver",
      points_required: 200,
      description: "Vous êtes un membre très actif",
      reward_type: "premium",
      reward_description: "Photos dédicacées",
      reward_image: "/assets/badges/photos-dedicacees.jpeg"
    },
    {
      id: 6,
      name: "Gold Engager",
      type: "engager",
      level: "gold",
      points_required: 500,
      description: "Vous êtes un pilier de la communauté",
      reward_type: "premium",
      reward_description: "Rencontre avec un artiste",
      reward_image: "/assets/badges/artist-meeting.jpeg"
    },
    
    // Badges Critic
    {
      id: 7,
      name: "Bronze Critic",
      type: "critic",
      level: "bronze",
      points_required: 50,
      description: "Vos opinions sont précieuses",
      reward_type: "standard",
      reward_description: "Accès à du contenu exclusif"
    },
    {
      id: 8,
      name: "Silver Critic",
      type: "critic",
      level: "silver",
      points_required: 200,
      description: "Votre goût est impeccable",
      reward_type: "standard",
      reward_description: "Photos dédicacées",
      reward_image: "/assets/badges/photos-dedicacees.jpeg"
    },
    {
      id: 9,
      name: "Gold Critic",
      type: "critic",
      level: "gold",
      points_required: 500,
      description: "Vous êtes un connaisseur reconnu",
      reward_type: "premium",
      reward_description: "Participation à des interviews live",
      reward_image: "/assets/badges/interview.jpg"
    },
    
    // Badges Challenger
    {
      id: 10,
      name: "Bronze Challenger",
      type: "challenger",
      level: "bronze",
      points_required: 100,
      description: "Vous relevez vos premiers défis",
      reward_type: "standard",
      reward_description: "Accès à des défis exclusifs"
    },
    {
      id: 11,
      name: "Silver Challenger",
      type: "challenger",
      level: "silver",
      points_required: 300,
      description: "Vous êtes un challenger déterminé",
      reward_type: "standard",
      reward_description: "Photos dédicacées",
      reward_image: "/assets/badges/photos-dedicacees.jpeg"
    },
    {
      id: 12,
      name: "Gold Challenger",
      type: "challenger",
      level: "gold",
      points_required: 700,
      description: "Vous êtes un maître des défis",
      reward_type: "premium",
      reward_description: "Invitation à un concert VIP",
      reward_image: "/assets/badges/concert.jpeg"
    }
  ];
  
  // Données simulées des badges utilisateur
  let userBadges = [
    {
      id: 1,
      user_id: 1,
      badge: badges[0], // Bronze Competitor
      earned_at: "2023-05-01T10:00:00Z",
      claimed_at: null
    },
    {
      id: 2,
      user_id: 1,
      badge: badges[3], // Bronze Engager
      earned_at: "2023-05-02T14:30:00Z",
      claimed_at: "2023-05-03T09:15:00Z"
    },
    {
      id: 3,
      user_id: 1,
      badge: badges[6], // Bronze Critic
      earned_at: "2023-05-10T11:20:00Z",
      claimed_at: null
    }
  ];
  
  return {
    // Récupérer tous les badges
    getAllBadges: function() {
      return badges;
    },
    
    // Récupérer un badge par son ID
    getBadgeById: function(badgeId) {
      return badges.find(b => b.id === badgeId);
    },
    
    // Récupérer les badges par type
    getBadgesByType: function(type) {
      return badges.filter(b => b.type === type);
    },
    
    // Récupérer les badges d'un utilisateur
    getUserBadges: function(userId) {
      return userBadges.filter(ub => ub.user_id === userId);
    },
    
    // Récupérer un badge utilisateur spécifique
    getUserBadgeByBadgeId: function(userId, badgeId) {
      return userBadges.find(ub => ub.user_id === userId && ub.badge.id === badgeId);
    },
    
    // Réclamer une récompense
    claimReward: function(userId, badgeId) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const userBadge = this.getUserBadgeByBadgeId(userId, badgeId);
          if (userBadge && !userBadge.claimed_at) {
            userBadge.claimed_at = new Date().toISOString();
            resolve({ success: true });
          } else {
            resolve({ success: false, error: "Badge non trouvé ou déjà réclamé" });
          }
        }, 500);
      });
    },
    
    // Simuler l'obtention d'un badge (pour tester)
    simulateEarnBadge: function(userId, type, points) {
      const userBadgeIds = userBadges.map(ub => ub.badge.id);
      
      // Trouver les badges du type spécifié qui ne sont pas encore gagnés
      const availableBadges = badges
        .filter(b => b.type === type && !userBadgeIds.includes(b.id))
        .filter(b => b.points_required <= points)
        .sort((a, b) => b.points_required - a.points_required); // trier par points décroissants
      
      if (availableBadges.length > 0) {
        const newBadge = availableBadges[0];
        const newUserBadge = {
          id: userBadges.length + 1,
          user_id: userId,
          badge: newBadge,
          earned_at: new Date().toISOString(),
          claimed_at: null
        };
        
        userBadges.push(newUserBadge);
        return { success: true, badge: newBadge };
      }
      
      return { success: false, message: "Pas de nouveau badge disponible" };
    }
  };
})();

// Initialisation du service de badge quand le document est chargé
document.addEventListener('DOMContentLoaded', function() {
  console.log('Badge service initialized!');
  
  // Initialiser le formulaire de simulation
  const simulationForm = document.getElementById('simulation-form');
  if (simulationForm) {
    simulationForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const userId = parseInt(document.getElementById('rewards-page').dataset.userId) || 1;
      const competitorPoints = parseInt(document.getElementById('competitor-points').value) || 0;
      const engagerPoints = parseInt(document.getElementById('engager-points').value) || 0;
      const criticPoints = parseInt(document.getElementById('critic-points').value) || 0;
      const challengerPoints = parseInt(document.getElementById('challenger-points').value) || 0;
      
      // Simuler l'obtention de badges
      const results = [
        window.badgeService.simulateEarnBadge(userId, 'competitor', competitorPoints),
        window.badgeService.simulateEarnBadge(userId, 'engager', engagerPoints),
        window.badgeService.simulateEarnBadge(userId, 'critic', criticPoints),
        window.badgeService.simulateEarnBadge(userId, 'challenger', challengerPoints)
      ].filter(r => r.success);
      
      // Afficher les résultats
      const notification = document.getElementById('notification');
      if (results.length > 0) {
        const badgeNames = results.map(r => r.badge.name).join(', ');
        notification.textContent = `Félicitations ! Vous avez gagné de nouveaux badges : ${badgeNames}`;
        notification.classList.remove('hidden', 'notification-error', 'notification-info');
        notification.classList.add('notification-success');
      } else {
        notification.textContent = "Vous n'avez pas gagné de nouveau badge. Continuez vos efforts !";
        notification.classList.remove('hidden', 'notification-success', 'notification-error');
        notification.classList.add('notification-info');
      }
      
      // Mettre à jour l'affichage des badges
      displayUserBadges();
      displayBadgesByType('competitor', '#competitor-badges');
      displayBadgesByType('engager', '#engager-badges');
      displayBadgesByType('critic', '#critic-badges');
      displayBadgesByType('challenger', '#challenger-badges');
      
      // Masquer la notification après 3 secondes
      setTimeout(() => {
        notification.classList.add('hidden');
      }, 3000);
    });
  }
}); 