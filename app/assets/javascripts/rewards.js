// Gestion des récompenses avec jQuery

$(document).ready(function() {
  // Si on est sur la page des récompenses
  if ($('#rewards-page').length > 0) {
    initBadgePage();
  }
  
  function initBadgePage() {
    // Récupérer l'ID utilisateur actuel
    const userId = parseInt($('#rewards-page').data('user-id')) || 1;
    
    // Afficher tous les badges disponibles
    displayAllBadges();
    
    // Afficher les badges de l'utilisateur
    displayUserBadges(userId);
    
    // Gestionnaire pour le formulaire de simulation
    $('#simulation-form').on('submit', function(e) {
      e.preventDefault();
      
      const competitorPoints = parseInt($('#competitor-points').val()) || 0;
      const engagerPoints = parseInt($('#engager-points').val()) || 0;
      const criticPoints = parseInt($('#critic-points').val()) || 0;
      const challengerPoints = parseInt($('#challenger-points').val()) || 0;
      
      const results = badgeService.checkAndAwardBadges(
        userId, 
        competitorPoints,
        engagerPoints,
        criticPoints,
        challengerPoints
      );
      
      if (results.awarded.length > 0) {
        const badgeNames = results.awarded.map(userBadge => userBadge.badge.name).join(", ");
        showNotification(`Félicitations ! Vous avez obtenu ${results.awarded.length} nouveau(x) badge(s): ${badgeNames}`, 'success');
        // Rafraîchir l'affichage
        displayUserBadges(userId);
      } else if (results.alreadyHas.length > 0) {
        showNotification("Vous possédez déjà tous les badges disponibles pour votre niveau actuel.", 'info');
      } else {
        showNotification("Continuez à participer pour gagner des badges !", 'info');
      }
    });
    
    // Délégation d'événement pour les boutons de réclamation de récompense
    $(document).on('click', '.claim-reward-btn', function() {
      const badgeId = parseInt($(this).data('badge-id'));
      const userBadge = badgeService.claimBadge(userId, badgeId);
      
      if (userBadge) {
        showNotification(`Vous avez réclamé la récompense: ${userBadge.badge.rewardDescription}`, 'success');
        // Rafraîchir l'affichage
        displayUserBadges(userId);
      } else {
        showNotification("Impossible de réclamer cette récompense.", 'error');
      }
    });
  }
  
  function displayAllBadges() {
    const $badgesList = $('#badges-list');
    if ($badgesList.length === 0) return;
    
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
      html += `<div class="badge-group mb-4">
        <h3 class="text-xl font-bold mb-2 capitalize">${type} Badges</h3>
        <div class="grid-badges">`;
      
      badgesByType[type].forEach(badge => {
        const levelClass = badge.level === 'bronze' ? 'bg-amber-600' : 
                        badge.level === 'silver' ? 'bg-gray-400' : 'bg-yellow-400';
        
        html += `
          <div class="badge-card">
            <div class="badge-level ${levelClass}">${badge.level}</div>
            <h4 class="badge-name">${badge.name}</h4>
            <p class="badge-desc">${badge.description}</p>
            <div class="badge-info">
              <p><span>Points requis:</span> ${badge.pointsRequired}</p>
              <p><span>Récompense:</span> ${badge.rewardDescription}</p>
            </div>
          </div>`;
      });
      
      html += `</div></div>`;
    });
    
    $badgesList.html(html);
  }
  
  function displayUserBadges(userId) {
    const $userBadgesList = $('#user-badges-list');
    if ($userBadgesList.length === 0) return;
    
    const userBadges = badgeService.getUserBadges(userId);
    
    if (userBadges.length === 0) {
      $userBadgesList.html(`
        <div class="empty-badges">
          <p>Vous n'avez pas encore gagné de badges. Participez à des activités pour en obtenir !</p>
        </div>`);
      return;
    }
    
    let html = '<div class="grid-badges">';
    
    userBadges.forEach(userBadge => {
      const badge = userBadge.badge;
      const levelClass = badge.level === 'bronze' ? 'bg-amber-600' : 
                      badge.level === 'silver' ? 'bg-gray-400' : 'bg-yellow-400';
      const earnedDate = userBadge.earnedAt ? new Date(userBadge.earnedAt).toLocaleDateString() : 'N/A';
      const claimedStatus = userBadge.claimedAt ? 
        `<span class="badge-claimed">Récompense réclamée le ${new Date(userBadge.claimedAt).toLocaleDateString()}</span>` : 
        `<button class="claim-reward-btn" data-badge-id="${badge.id}">Réclamer la récompense</button>`;
      
      html += `
        <div class="badge-card">
          <div class="badge-level ${levelClass}">${badge.level}</div>
          <h4 class="badge-name">${badge.name}</h4>
          <p class="badge-desc">${badge.description}</p>
          <div class="badge-info">
            <p><span>Obtenu le:</span> ${earnedDate}</p>
            <p><span>Points lors de l'obtention:</span> ${userBadge.pointsAtEarned}</p>
            <p><span>Récompense:</span> ${badge.rewardDescription}</p>
          </div>
          <div class="badge-actions">
            ${claimedStatus}
          </div>
        </div>`;
    });
    
    html += '</div>';
    $userBadgesList.html(html);
  }
  
  function showNotification(message, type = 'success') {
    const $notification = $('#notification');
    if ($notification.length === 0) return;
    
    $notification.text(message);
    $notification.removeClass('notification-success notification-error notification-info');
    
    if (type === 'success') {
      $notification.addClass('notification-success');
    } else if (type === 'error') {
      $notification.addClass('notification-error');
    } else {
      $notification.addClass('notification-info');
    }
    
    $notification.removeClass('hidden');
    
    // Masquer la notification après 5 secondes
    setTimeout(function() {
      $notification.addClass('hidden');
    }, 5000);
  }
}); 