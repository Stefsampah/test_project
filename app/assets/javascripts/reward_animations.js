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
}

// 🚀 Initialiser le système d'animations
document.addEventListener('DOMContentLoaded', () => {
  window.rewardAnimationSystem = new RewardAnimationSystem();
  
  // Exposer les méthodes de test globalement
  window.testRewardAnimation = (type) => {
    window.rewardAnimationSystem.testAnimation(type);
  };
});

// 🎯 Déclencher une animation depuis le backend (via Turbo)
document.addEventListener('turbo:load', () => {
  // Vérifier s'il y a une récompense à afficher
  const rewardData = document.querySelector('[data-reward-to-show]');
  if (rewardData) {
    const data = JSON.parse(rewardData.dataset.rewardToShow);
    window.rewardAnimationSystem.triggerRewardAnimation(data);
    rewardData.remove();
  }
});
