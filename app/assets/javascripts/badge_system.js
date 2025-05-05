// Badge System - Un système temporaire en JavaScript pour gérer les badges
// jusqu'à ce que le backend Ruby soit opérationnel

class Badge {
  constructor(id, name, badgeType, level, pointsRequired, description, rewardType, rewardDescription) {
    this.id = id;
    this.name = name;
    this.badgeType = badgeType;
    this.level = level;
    this.pointsRequired = pointsRequired;
    this.description = description;
    this.rewardType = rewardType;
    this.rewardDescription = rewardDescription;
  }
}

class UserBadge {
  constructor(userId, badge, earnedAt = null, pointsAtEarned = 0, claimedAt = null) {
    this.userId = userId;
    this.badge = badge;
    this.earnedAt = earnedAt;
    this.pointsAtEarned = pointsAtEarned;
    this.claimedAt = claimedAt;
  }
}

class BadgeService {
  constructor() {
    this.badges = [];
    this.userBadges = {};
    this.initializeBadges();
  }

  initializeBadges() {
    // Competitor badges
    this.badges.push(
      new Badge(1, 'Bronze Competitor', 'competitor', 'bronze', 1000, 
                'A solid start in the competition!', 'standard', 'Access to exclusive playlists')
    );
    this.badges.push(
      new Badge(2, 'Silver Competitor', 'competitor', 'silver', 3000, 
                'You\'re becoming a force to be reckoned with!', 'standard', 'Photos dédicacées')
    );
    this.badges.push(
      new Badge(3, 'Gold Competitor', 'competitor', 'gold', 5000, 
                'A true champion of the competition!', 'premium', 'Invitation à un concert VIP')
    );

    // Engager badges
    this.badges.push(
      new Badge(4, 'Bronze Engager', 'engager', 'bronze', 500, 
                'Starting to make your voice heard!', 'standard', 'Badge exclusif sur votre profil')
    );
    this.badges.push(
      new Badge(5, 'Silver Engager', 'engager', 'silver', 1500, 
                'Your engagement is remarkable!', 'standard', 'Accès à des fonctionnalités exclusives')
    );
    this.badges.push(
      new Badge(6, 'Gold Engager', 'engager', 'gold', 3000, 
                'A true community pillar!', 'premium', 'Discussion avec votre artiste préféré')
    );

    // Critic badges
    this.badges.push(
      new Badge(7, 'Bronze Critic', 'critic', 'bronze', 300, 
                'Your critical eye is developing!', 'standard', 'Accès anticipé aux nouveaux contenus')
    );
    this.badges.push(
      new Badge(8, 'Silver Critic', 'critic', 'silver', 1000, 
                'Your reviews are becoming influential!', 'standard', 'Merchandising exclusif')
    );
    this.badges.push(
      new Badge(9, 'Gold Critic', 'critic', 'gold', 2000, 
                'A respected voice in the community!', 'premium', 'Invitation à des sessions d\'écoute privées')
    );

    // Challenger badges
    this.badges.push(
      new Badge(10, 'Bronze Challenger', 'challenger', 'bronze', 200, 
                'Starting to make challenges!', 'standard', 'Accès à des défis spéciaux')
    );
    this.badges.push(
      new Badge(11, 'Silver Challenger', 'challenger', 'silver', 800, 
                'Your challenges are getting popular!', 'standard', 'Mise en avant de vos défis')
    );
    this.badges.push(
      new Badge(12, 'Gold Challenger', 'challenger', 'gold', 1500, 
                'A challenge master!', 'premium', 'Co-création de défis officiels')
    );
  }

  // Récupérer tous les badges
  getAllBadges() {
    return this.badges;
  }

  // Récupérer les badges par type
  getBadgesByType(type) {
    return this.badges.filter(badge => badge.badgeType === type);
  }

  // Récupérer les badges par niveau
  getBadgesByLevel(level) {
    return this.badges.filter(badge => badge.level === level);
  }

  // Récupérer un badge spécifique
  getBadge(badgeId) {
    return this.badges.find(badge => badge.id === badgeId);
  }

  // Récupérer les badges d'un utilisateur
  getUserBadges(userId) {
    return this.userBadges[userId] || [];
  }

  // Vérifier si un utilisateur a un badge spécifique
  hasUserBadge(userId, badgeId) {
    const userBadges = this.getUserBadges(userId);
    return userBadges.some(userBadge => userBadge.badge.id === badgeId);
  }

  // Attribuer un badge à un utilisateur
  awardBadge(userId, badgeId, points) {
    if (this.hasUserBadge(userId, badgeId)) {
      return false; // L'utilisateur a déjà ce badge
    }
    
    const badge = this.getBadge(badgeId);
    if (!badge) {
      return false; // Le badge n'existe pas
    }
    
    if (points < badge.pointsRequired) {
      return false; // L'utilisateur n'a pas assez de points
    }
    
    if (!this.userBadges[userId]) {
      this.userBadges[userId] = [];
    }
    
    const now = new Date();
    const userBadge = new UserBadge(userId, badge, now, points);
    this.userBadges[userId].push(userBadge);
    
    // Enregistrer dans le localStorage pour persistance temporaire
    this.saveToLocalStorage();
    
    return userBadge;
  }

  // Vérifier et attribuer automatiquement des badges en fonction des points
  checkAndAwardBadges(userId, competitorPoints, engagerPoints, criticPoints, challengerPoints) {
    const results = {
      awarded: [],
      alreadyHas: []
    };
    
    // Vérifier les badges de type competitor
    this.getBadgesByType('competitor').forEach(badge => {
      if (competitorPoints >= badge.pointsRequired) {
        if (!this.hasUserBadge(userId, badge.id)) {
          const userBadge = this.awardBadge(userId, badge.id, competitorPoints);
          if (userBadge) {
            results.awarded.push(userBadge);
          }
        } else {
          results.alreadyHas.push(badge);
        }
      }
    });
    
    // Vérifier les badges de type engager
    this.getBadgesByType('engager').forEach(badge => {
      if (engagerPoints >= badge.pointsRequired) {
        if (!this.hasUserBadge(userId, badge.id)) {
          const userBadge = this.awardBadge(userId, badge.id, engagerPoints);
          if (userBadge) {
            results.awarded.push(userBadge);
          }
        } else {
          results.alreadyHas.push(badge);
        }
      }
    });
    
    // Vérifier les badges de type critic
    this.getBadgesByType('critic').forEach(badge => {
      if (criticPoints >= badge.pointsRequired) {
        if (!this.hasUserBadge(userId, badge.id)) {
          const userBadge = this.awardBadge(userId, badge.id, criticPoints);
          if (userBadge) {
            results.awarded.push(userBadge);
          }
        } else {
          results.alreadyHas.push(badge);
        }
      }
    });
    
    // Vérifier les badges de type challenger
    this.getBadgesByType('challenger').forEach(badge => {
      if (challengerPoints >= badge.pointsRequired) {
        if (!this.hasUserBadge(userId, badge.id)) {
          const userBadge = this.awardBadge(userId, badge.id, challengerPoints);
          if (userBadge) {
            results.awarded.push(userBadge);
          }
        } else {
          results.alreadyHas.push(badge);
        }
      }
    });
    
    return results;
  }

  // Marquer un badge comme réclamé
  claimBadge(userId, badgeId) {
    const userBadges = this.getUserBadges(userId);
    const userBadgeIndex = userBadges.findIndex(userBadge => userBadge.badge.id === badgeId);
    
    if (userBadgeIndex === -1) {
      return false; // L'utilisateur n'a pas ce badge
    }
    
    if (userBadges[userBadgeIndex].claimedAt) {
      return false; // Le badge a déjà été réclamé
    }
    
    userBadges[userBadgeIndex].claimedAt = new Date();
    
    // Enregistrer dans le localStorage pour persistance temporaire
    this.saveToLocalStorage();
    
    return userBadges[userBadgeIndex];
  }

  // Sauvegarder les données dans le localStorage
  saveToLocalStorage() {
    try {
      localStorage.setItem('badge_system_data', JSON.stringify({
        userBadges: this.userBadges
      }));
    } catch (error) {
      console.error('Erreur lors de la sauvegarde des données de badges:', error);
    }
  }

  // Charger les données depuis le localStorage
  loadFromLocalStorage() {
    try {
      const data = localStorage.getItem('badge_system_data');
      if (data) {
        const parsedData = JSON.parse(data);
        
        // Restaurer les UserBadges avec leurs objets Badge correspondants
        if (parsedData.userBadges) {
          Object.keys(parsedData.userBadges).forEach(userId => {
            this.userBadges[userId] = parsedData.userBadges[userId].map(userBadgeData => {
              const badge = this.getBadge(userBadgeData.badge.id);
              return new UserBadge(
                userBadgeData.userId,
                badge,
                userBadgeData.earnedAt ? new Date(userBadgeData.earnedAt) : null,
                userBadgeData.pointsAtEarned,
                userBadgeData.claimedAt ? new Date(userBadgeData.claimedAt) : null
              );
            });
          });
        }
      }
    } catch (error) {
      console.error('Erreur lors du chargement des données de badges:', error);
    }
  }
}

// Exporter le service comme variable globale
var badgeService = new BadgeService();

// Initialiser au chargement de la page
$(document).ready(function() {
  badgeService.loadFromLocalStorage();
}); 