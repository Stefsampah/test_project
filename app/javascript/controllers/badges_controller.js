import { Controller } from "@hotwired/stimulus"
import badgeService from "../badge_system"

export default class extends Controller {
  static targets = ["badgesList", "userBadgesList", "notification", "pointsForm"]
  static values = {
    userId: Number,
    competitorPoints: Number,
    engagerPoints: Number,
    criticPoints: Number,
    challengerPoints: Number
  }

  connect() {
    // Valeurs par défaut si non fournies
    if (!this.hasUserIdValue) {
      this.userIdValue = 1; // Utilisateur par défaut pour les tests
    }

    this.loadBadges();
    this.loadUserBadges();
  }

  loadBadges() {
    if (!this.hasBadgesListTarget) return;

    const badges = badgeService.getAllBadges();
    const badgesByType = {};
    
    // Grouper les badges par type
    badges.forEach(badge => {
      if (!badgesByType[badge.badgeType]) {
        badgesByType[badge.badgeType] = [];
      }
      badgesByType[badge.badgeType].push(badge);
    });

    // Construire le HTML pour chaque type de badge
    let html = '';
    Object.keys(badgesByType).forEach(type => {
      html += `<div class="badge-group mb-8">
        <h3 class="text-xl font-bold mb-4 capitalize">${type} Badges</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">`;
      
      badgesByType[type].forEach(badge => {
        const levelClass = badge.level === 'bronze' ? 'bg-amber-600' : 
                        badge.level === 'silver' ? 'bg-gray-400' : 'bg-yellow-400';
        
        html += `
          <div class="badge-card border rounded-lg p-4 shadow-md relative">
            <div class="absolute top-2 right-2">
              <span class="${levelClass} text-white px-2 py-1 rounded text-xs uppercase">${badge.level}</span>
            </div>
            <h4 class="text-lg font-semibold">${badge.name}</h4>
            <p class="text-sm text-gray-600 mb-2">${badge.description}</p>
            <div class="text-xs text-gray-500">
              <p><span class="font-semibold">Points requis:</span> ${badge.pointsRequired}</p>
              <p><span class="font-semibold">Récompense:</span> ${badge.rewardDescription}</p>
            </div>
          </div>`;
      });
      
      html += `</div></div>`;
    });

    this.badgesListTarget.innerHTML = html;
  }

  loadUserBadges() {
    if (!this.hasUserBadgesListTarget) return;

    const userBadges = badgeService.getUserBadges(this.userIdValue);
    
    if (userBadges.length === 0) {
      this.userBadgesListTarget.innerHTML = `
        <div class="p-4 bg-gray-100 rounded-lg text-center">
          <p class="text-gray-600">Vous n'avez pas encore gagné de badges. Participez à des activités pour en obtenir !</p>
        </div>`;
      return;
    }

    let html = '<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">';
    
    userBadges.forEach(userBadge => {
      const badge = userBadge.badge;
      const levelClass = badge.level === 'bronze' ? 'bg-amber-600' : 
                      badge.level === 'silver' ? 'bg-gray-400' : 'bg-yellow-400';
      const earnedDate = userBadge.earnedAt ? new Date(userBadge.earnedAt).toLocaleDateString() : 'N/A';
      const claimedStatus = userBadge.claimedAt ? 
        `<span class="text-green-600">Récompense réclamée le ${new Date(userBadge.claimedAt).toLocaleDateString()}</span>` : 
        `<button data-action="badges#claimReward" data-badge-id="${badge.id}" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded text-sm">Réclamer la récompense</button>`;
      
      html += `
        <div class="badge-card border rounded-lg p-4 shadow-md relative">
          <div class="absolute top-2 right-2">
            <span class="${levelClass} text-white px-2 py-1 rounded text-xs uppercase">${badge.level}</span>
          </div>
          <h4 class="text-lg font-semibold">${badge.name}</h4>
          <p class="text-sm text-gray-600 mb-2">${badge.description}</p>
          <div class="text-xs text-gray-500 mb-3">
            <p><span class="font-semibold">Obtenu le:</span> ${earnedDate}</p>
            <p><span class="font-semibold">Points lors de l'obtention:</span> ${userBadge.pointsAtEarned}</p>
            <p><span class="font-semibold">Récompense:</span> ${badge.rewardDescription}</p>
          </div>
          <div class="mt-2">
            ${claimedStatus}
          </div>
        </div>`;
    });
    
    html += '</div>';
    this.userBadgesListTarget.innerHTML = html;
  }

  claimReward(event) {
    const badgeId = parseInt(event.currentTarget.dataset.badgeId);
    const userBadge = badgeService.claimBadge(this.userIdValue, badgeId);
    
    if (userBadge) {
      this.showNotification(`Vous avez réclamé la récompense: ${userBadge.badge.rewardDescription}`);
      this.loadUserBadges(); // Rafraîchir l'affichage
    } else {
      this.showNotification("Impossible de réclamer cette récompense.", "error");
    }
  }

  checkForBadges(event) {
    event.preventDefault();
    
    const competitorPoints = this.competitorPointsValue;
    const engagerPoints = this.engagerPointsValue;
    const criticPoints = this.criticPointsValue;
    const challengerPoints = this.challengerPointsValue;
    
    const results = badgeService.checkAndAwardBadges(
      this.userIdValue, 
      competitorPoints, 
      engagerPoints, 
      criticPoints, 
      challengerPoints
    );
    
    if (results.awarded.length > 0) {
      const badgeNames = results.awarded.map(userBadge => userBadge.badge.name).join(", ");
      this.showNotification(`Félicitations ! Vous avez obtenu ${results.awarded.length} nouveau(x) badge(s): ${badgeNames}`);
      this.loadUserBadges(); // Rafraîchir l'affichage des badges
    } else if (results.alreadyHas.length > 0) {
      this.showNotification("Vous possédez déjà tous les badges disponibles pour votre niveau actuel.", "info");
    } else {
      this.showNotification("Continuez à participer pour gagner des badges !", "info");
    }
  }

  updateCompetitorPoints(event) {
    this.competitorPointsValue = parseInt(event.target.value) || 0;
  }

  updateEngagerPoints(event) {
    this.engagerPointsValue = parseInt(event.target.value) || 0;
  }

  updateCriticPoints(event) {
    this.criticPointsValue = parseInt(event.target.value) || 0;
  }

  updateChallengerPoints(event) {
    this.challengerPointsValue = parseInt(event.target.value) || 0;
  }

  showNotification(message, type = "success") {
    if (!this.hasNotificationTarget) return;
    
    const notification = this.notificationTarget;
    notification.textContent = message;
    
    // Appliquer la classe en fonction du type
    notification.className = "notification p-4 rounded mb-4 ";
    if (type === "success") {
      notification.className += "bg-green-100 text-green-800 border border-green-200";
    } else if (type === "error") {
      notification.className += "bg-red-100 text-red-800 border border-red-200";
    } else {
      notification.className += "bg-blue-100 text-blue-800 border border-blue-200";
    }
    
    notification.classList.remove("hidden");
    
    // Masquer la notification après 5 secondes
    setTimeout(() => {
      notification.classList.add("hidden");
    }, 5000);
  }
} 