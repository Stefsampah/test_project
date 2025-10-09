// 🎉 Système d'Animations de Récompenses - Tube'NPlay

class RewardAnimationSystem {
  constructor() {
    this.isAnimating = false;
    this.init();
  }

  init() {
    // Écouter les événements de récompense
    document.addEventListener('rewardUnlocked', (event) => {
      this.triggerRewardAnimation(event.detail);
    });
    
    // Écouter les événements de badge
    document.addEventListener('badgeUnlocked', (event) => {
      this.triggerBadgeAnimation(event.detail);
    });
  }

  // 🎯 Déclencher l'animation complète de récompense
  triggerRewardAnimation(rewardData) {
    if (this.isAnimating) return;
    this.isAnimating = true;

    const sequence = [
      () => this.showNotification(rewardData),
      () => this.showGift(rewardData),
      () => this.waitForGiftClick(),
      () => this.explodeGift(rewardData),
      () => this.showCongratulations(rewardData),
      () => this.cleanup()
    ];

    this.executeSequence(sequence, 0);
  }

  // 🏆 Déclencher l'animation complète de badge
  triggerBadgeAnimation(badgeData) {
    if (this.isAnimating) return;
    this.isAnimating = true;

    const sequence = [
      () => this.showBadgeNotification(badgeData),
      () => this.showBadgeGift(badgeData),
      () => this.waitForGiftClick(),
      () => this.explodeBadgeGift(badgeData),
      () => this.showBadgeCongratulations(badgeData),
      () => this.cleanup()
    ];

    this.executeSequence(sequence, 0);
  }

  // 📢 Afficher la notification popup
  showNotification(rewardData) {
    return new Promise((resolve) => {
      const popup = document.createElement('div');
      popup.className = 'reward-notification-popup';
      popup.innerHTML = `
        <div class="notification-content">
          <div class="notification-icon">🎉</div>
          <div class="notification-text">
            <div>Nouvelle récompense disponible !</div>
            <div style="font-size: 0.9rem; opacity: 0.9;">${rewardData.type}</div>
          </div>
        </div>
      `;

      document.body.appendChild(popup);

      // Animation d'entrée
      setTimeout(() => {
        popup.classList.add('show');
      }, 100);

      // Auto-hide après 4 secondes
      setTimeout(() => {
        popup.classList.remove('show');
        setTimeout(() => {
          document.body.removeChild(popup);
          resolve();
        }, 500);
      }, 4000);
    });
  }

  // 🏆 Afficher la notification popup pour les badges
  showBadgeNotification(badgeData) {
    return new Promise((resolve) => {
      const popup = document.createElement('div');
      popup.className = 'reward-notification-popup badge-notification';
      popup.innerHTML = `
        <div class="notification-content">
          <div class="notification-icon">🏆</div>
          <div class="notification-text">
            <div>Nouveau badge débloqué !</div>
            <div style="font-size: 0.9rem; opacity: 0.9;">${badgeData.title}</div>
          </div>
        </div>
      `;

      document.body.appendChild(popup);

      // Animation d'entrée
      setTimeout(() => {
        popup.classList.add('show');
      }, 100);

      // Auto-hide après 4 secondes
      setTimeout(() => {
        popup.classList.remove('show');
        setTimeout(() => {
          document.body.removeChild(popup);
          resolve();
        }, 500);
      }, 4000);
    });
  }

  // 🎁 Afficher le cadeau
  showGift(rewardData) {
    return new Promise((resolve) => {
      const giftContainer = document.createElement('div');
      giftContainer.className = 'reward-gift-container';
      giftContainer.innerHTML = `
        <div class="reward-gift-box">
          <div class="reward-gift-ribbon"></div>
        </div>
      `;

      document.body.appendChild(giftContainer);

      // Animation d'entrée
      setTimeout(() => {
        giftContainer.classList.add('show');
      }, 100);

      // Stocker la référence pour le clic
      this.giftContainer = giftContainer;
      this.giftResolve = resolve;
    });
  }

  // 🏆 Afficher le cadeau pour les badges
  showBadgeGift(badgeData) {
    return new Promise((resolve) => {
      const giftContainer = document.createElement('div');
      giftContainer.className = 'reward-gift-container badge-gift-container';
      giftContainer.innerHTML = `
        <div class="reward-gift-box badge-gift-box">
          <div class="reward-gift-ribbon badge-gift-ribbon"></div>
          <div class="badge-icon">🏆</div>
        </div>
      `;

      document.body.appendChild(giftContainer);

      // Animation d'entrée
      setTimeout(() => {
        giftContainer.classList.add('show');
      }, 100);

      // Stocker la référence pour le clic
      this.giftContainer = giftContainer;
      this.giftResolve = resolve;
    });
  }

  // ⏳ Attendre le clic sur le cadeau
  waitForGiftClick() {
    return new Promise((resolve) => {
      this.giftContainer.addEventListener('click', () => {
        resolve();
      }, { once: true });
    });
  }

  // 💥 Explosion du cadeau
  explodeGift(rewardData) {
    return new Promise((resolve) => {
      // Animation de sortie du cadeau
      this.giftContainer.style.transform = 'translate(-50%, -50%) scale(1.5)';
      this.giftContainer.style.opacity = '0';
      this.giftContainer.style.transition = 'all 0.3s ease';

      // Créer l'explosion
      this.createExplosion();
      this.createConfetti();
      this.createSparkles();
      this.createParticles();

      setTimeout(() => {
        document.body.removeChild(this.giftContainer);
        resolve();
      }, 300);
    });
  }

  // 🏆 Explosion du cadeau pour les badges
  explodeBadgeGift(badgeData) {
    return new Promise((resolve) => {
      // Animation de sortie du cadeau
      this.giftContainer.style.transform = 'translate(-50%, -50%) scale(1.5)';
      this.giftContainer.style.opacity = '0';
      this.giftContainer.style.transition = 'all 0.3s ease';

      // Créer l'explosion avec des couleurs de badge
      this.createBadgeExplosion();
      this.createBadgeConfetti();
      this.createBadgeSparkles();
      this.createBadgeParticles();

      setTimeout(() => {
        document.body.removeChild(this.giftContainer);
        resolve();
      }, 300);
    });
  }

  // 🎊 Créer l'explosion de confettis
  createExplosion() {
    const explosionContainer = document.createElement('div');
    explosionContainer.className = 'reward-explosion-container';
    document.body.appendChild(explosionContainer);

    // Créer 50 confettis
    for (let i = 0; i < 50; i++) {
      const confetti = document.createElement('div');
      confetti.className = 'confetti-piece';
      confetti.style.left = Math.random() * 100 + '%';
      confetti.style.animationDelay = Math.random() * 2 + 's';
      confetti.style.animationDuration = (Math.random() * 2 + 2) + 's';
      explosionContainer.appendChild(confetti);
    }

    // Nettoyer après l'animation
    setTimeout(() => {
      document.body.removeChild(explosionContainer);
    }, 5000);
  }

  // ✨ Créer les étincelles
  createSparkles() {
    const sparkleContainer = document.createElement('div');
    sparkleContainer.className = 'reward-explosion-container';
    document.body.appendChild(sparkleContainer);

    // Créer 30 étincelles
    for (let i = 0; i < 30; i++) {
      const sparkle = document.createElement('div');
      sparkle.className = 'sparkle';
      sparkle.style.left = Math.random() * 100 + '%';
      sparkle.style.top = Math.random() * 100 + '%';
      sparkle.style.animationDelay = Math.random() * 1 + 's';
      sparkleContainer.appendChild(sparkle);
    }

    setTimeout(() => {
      document.body.removeChild(sparkleContainer);
    }, 3000);
  }

  // 🎆 Créer les particules d'explosion
  createParticles() {
    const particleContainer = document.createElement('div');
    particleContainer.className = 'reward-explosion-container';
    document.body.appendChild(particleContainer);

    // Créer 20 particules
    for (let i = 0; i < 20; i++) {
      const particle = document.createElement('div');
      particle.className = 'particle';
      particle.style.left = '50%';
      particle.style.top = '50%';
      
      const angle = (Math.PI * 2 * i) / 20;
      const distance = 100 + Math.random() * 200;
      const dx = Math.cos(angle) * distance;
      const dy = Math.sin(angle) * distance;
      
      particle.style.setProperty('--dx', dx + 'px');
      particle.style.setProperty('--dy', dy + 'px');
      particle.style.animationDelay = Math.random() * 0.5 + 's';
      
      particleContainer.appendChild(particle);
    }

    setTimeout(() => {
      document.body.removeChild(particleContainer);
    }, 2000);
  }

  // 🏆 Créer l'explosion de confettis pour les badges
  createBadgeExplosion() {
    const explosionContainer = document.createElement('div');
    explosionContainer.className = 'reward-explosion-container badge-explosion';
    document.body.appendChild(explosionContainer);

    // Créer 50 confettis avec des couleurs de badge
    for (let i = 0; i < 50; i++) {
      const confetti = document.createElement('div');
      confetti.className = 'confetti-piece badge-confetti';
      confetti.style.left = Math.random() * 100 + '%';
      confetti.style.animationDelay = Math.random() * 2 + 's';
      confetti.style.animationDuration = (Math.random() * 2 + 2) + 's';
      explosionContainer.appendChild(confetti);
    }

    // Nettoyer après l'animation
    setTimeout(() => {
      document.body.removeChild(explosionContainer);
    }, 5000);
  }

  // ✨ Créer les étincelles pour les badges
  createBadgeSparkles() {
    const sparkleContainer = document.createElement('div');
    sparkleContainer.className = 'reward-explosion-container badge-sparkles';
    document.body.appendChild(sparkleContainer);

    // Créer 30 étincelles dorées
    for (let i = 0; i < 30; i++) {
      const sparkle = document.createElement('div');
      sparkle.className = 'sparkle badge-sparkle';
      sparkle.style.left = Math.random() * 100 + '%';
      sparkle.style.top = Math.random() * 100 + '%';
      sparkle.style.animationDelay = Math.random() * 1 + 's';
      sparkleContainer.appendChild(sparkle);
    }

    setTimeout(() => {
      document.body.removeChild(sparkleContainer);
    }, 3000);
  }

  // 🎆 Créer les particules d'explosion pour les badges
  createBadgeParticles() {
    const particleContainer = document.createElement('div');
    particleContainer.className = 'reward-explosion-container badge-particles';
    document.body.appendChild(particleContainer);

    // Créer 20 particules avec des couleurs de badge
    for (let i = 0; i < 20; i++) {
      const particle = document.createElement('div');
      particle.className = 'particle badge-particle';
      particle.style.left = '50%';
      particle.style.top = '50%';
      
      const angle = (Math.PI * 2 * i) / 20;
      const distance = 100 + Math.random() * 200;
      const dx = Math.cos(angle) * distance;
      const dy = Math.sin(angle) * distance;
      
      particle.style.setProperty('--dx', dx + 'px');
      particle.style.setProperty('--dy', dy + 'px');
      particle.style.animationDelay = Math.random() * 0.5 + 's';
      
      particleContainer.appendChild(particle);
    }

    setTimeout(() => {
      document.body.removeChild(particleContainer);
    }, 2000);
  }

  // 🎉 Afficher le message de félicitations
  showCongratulations(rewardData) {
    return new Promise((resolve) => {
      const message = document.createElement('div');
      message.className = 'congratulations-message';
      message.innerHTML = `
        <div>🎉 FÉLICITATIONS ! 🎉</div>
        <div class="reward-title">${rewardData.title}</div>
        <div style="font-size: 1rem; margin-top: 10px; opacity: 0.9;">
          ${rewardData.description}
        </div>
      `;

      document.body.appendChild(message);

      // Auto-hide après 4 secondes
      setTimeout(() => {
        message.style.opacity = '0';
        message.style.transform = 'translateX(-50%) scale(0.8)';
        message.style.transition = 'all 0.5s ease';
        
        setTimeout(() => {
          document.body.removeChild(message);
          resolve();
        }, 500);
      }, 4000);
    });
  }

  // 🏆 Afficher le message de félicitations pour les badges
  showBadgeCongratulations(badgeData) {
    return new Promise((resolve) => {
      const message = document.createElement('div');
      message.className = 'congratulations-message badge-congratulations';
      message.innerHTML = `
        <div>🏆 BADGE DÉBLOQUÉ ! 🏆</div>
        <div class="reward-title">${badgeData.title}</div>
        <div style="font-size: 1rem; margin-top: 10px; opacity: 0.9;">
          ${badgeData.description}
        </div>
        <div style="font-size: 0.9rem; margin-top: 5px; opacity: 0.8;">
          Niveau: ${badgeData.level} | Type: ${badgeData.badge_type}
        </div>
      `;

      document.body.appendChild(message);

      // Auto-hide après 4 secondes
      setTimeout(() => {
        message.style.opacity = '0';
        message.style.transform = 'translateX(-50%) scale(0.8)';
        message.style.transition = 'all 0.5s ease';
        
        setTimeout(() => {
          document.body.removeChild(message);
          resolve();
        }, 500);
      }, 4000);
    });
  }

  // 🧹 Nettoyage final
  cleanup() {
    this.isAnimating = false;
    this.giftContainer = null;
    this.giftResolve = null;
  }

  // 🔄 Exécuter une séquence d'animations
  async executeSequence(sequence, index) {
    if (index >= sequence.length) return;
    
    await sequence[index]();
    this.executeSequence(sequence, index + 1);
  }

  // 🎮 Méthode de test pour déclencher une animation
  testAnimation(rewardType = 'challenge') {
    const testData = {
      type: rewardType.toUpperCase(),
      title: this.getRewardTitle(rewardType),
      description: this.getRewardDescription(rewardType)
    };

    this.triggerRewardAnimation(testData);
  }

  // 🏆 Méthode de test pour déclencher une animation de badge
  testBadgeAnimation(badgeType = 'competitor', level = 'bronze') {
    const testData = {
      type: 'badge',
      title: `${level.charAt(0).toUpperCase() + level.slice(1)} ${badgeType.charAt(0).toUpperCase() + badgeType.slice(1)}`,
      description: this.getBadgeDescription(badgeType),
      level: level,
      badge_type: badgeType,
      points_required: this.getBadgePoints(level),
      reward_type: 'standard'
    };

    this.triggerBadgeAnimation(testData);
  }

  // 📝 Obtenir le titre de la récompense
  getRewardTitle(type) {
    const titles = {
      challenge: 'Récompense Challenge Débloquée !',
      exclusif: 'Récompense Exclusif Débloquée !',
      premium: 'Récompense Premium Débloquée !',
      ultime: 'Récompense Ultime Débloquée !'
    };
    return titles[type] || 'Récompense Débloquée !';
  }

  // 📄 Obtenir la description de la récompense
  getRewardDescription(type) {
    const descriptions = {
      challenge: 'Vous avez débloqué une playlist exclusive !',
      exclusif: 'Accès à du contenu premium spécial !',
      premium: 'Contenu VIP et rencontres avec artistes !',
      ultime: 'Récompense ultime - vous êtes un champion !'
    };
    return descriptions[type] || 'Nouvelle récompense disponible !';
  }

  // 🏆 Obtenir la description du badge
  getBadgeDescription(type) {
    const descriptions = {
      competitor: 'Vous êtes un vrai compétiteur ! Continuez à jouer pour débloquer plus de badges.',
      engager: 'Vous vous engagez dans le jeu ! Votre participation est remarquable.',
      critic: 'Vous avez un œil critique ! Vos opinions comptent dans la communauté.',
      challenger: 'Vous relevez tous les défis ! Vous êtes un champion du jeu.'
    };
    return descriptions[type] || 'Nouveau badge débloqué ! Continuez à jouer pour en débloquer d\'autres.';
  }

  // 🎯 Obtenir les points requis pour le niveau de badge
  getBadgePoints(level) {
    const points = {
      bronze: 500,
      silver: 1500,
      gold: 3000
    };
    return points[level] || 500;
  }
}

// 🚀 Initialiser le système d'animations
document.addEventListener('DOMContentLoaded', () => {
  console.log('🎉 Initialisation du système d\'animations...');
  window.rewardAnimationSystem = new RewardAnimationSystem();
  
  // Exposer les méthodes de test globalement
  window.testRewardAnimation = (type) => {
    console.log('🎉 Test animation récompense:', type);
    window.rewardAnimationSystem.testAnimation(type);
  };
  
  window.testBadgeAnimation = (badgeType, level) => {
    console.log('🏆 Test animation badge:', badgeType, level);
    window.rewardAnimationSystem.testBadgeAnimation(badgeType, level);
  };
  
  console.log('✅ Système d\'animations initialisé avec succès !');
  console.log('📋 Fonctions disponibles:');
  console.log('  - testRewardAnimation(type)');
  console.log('  - testBadgeAnimation(badgeType, level)');
});

// 🎯 Déclencher une animation depuis le backend (via Turbo)
document.addEventListener('turbo:load', () => {
  console.log('🎉 Turbo:load détecté, réinitialisation du système d\'animations...');
  
  // Réinitialiser le système d'animations si nécessaire
  if (!window.rewardAnimationSystem) {
    window.rewardAnimationSystem = new RewardAnimationSystem();
    
    // Exposer les méthodes de test globalement
    window.testRewardAnimation = (type) => {
      console.log('🎉 Test animation récompense:', type);
      window.rewardAnimationSystem.testAnimation(type);
    };
    
    window.testBadgeAnimation = (badgeType, level) => {
      console.log('🏆 Test animation badge:', badgeType, level);
      window.rewardAnimationSystem.testBadgeAnimation(badgeType, level);
    };
    
    console.log('✅ Système d\'animations réinitialisé avec succès !');
  }
  
  // Vérifier s'il y a une récompense à afficher
  const rewardData = document.querySelector('[data-reward-to-show]');
  if (rewardData) {
    const data = JSON.parse(rewardData.dataset.rewardToShow);
    window.rewardAnimationSystem.triggerRewardAnimation(data);
    rewardData.remove();
  }
});