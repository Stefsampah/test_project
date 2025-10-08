// 🎉 Contrôleur Stimulus pour les Animations de Récompenses

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["gift", "notification", "message"]
  static values = { 
    rewardData: Object,
    autoTrigger: Boolean 
  }

  connect() {
    console.log("🎉 Reward Animation Controller connected")
    
    // Déclencher automatiquement l'animation si demandé
    if (this.autoTriggerValue) {
      this.triggerAnimation()
    }
  }

  // 🎯 Déclencher l'animation complète
  triggerAnimation() {
    if (!window.rewardAnimationSystem) {
      console.error("Reward Animation System not loaded")
      return
    }

    const rewardData = this.rewardDataValue || {
      type: "Challenge",
      title: "Récompense Débloquée !",
      description: "Vous avez débloqué une nouvelle récompense !"
    }

    window.rewardAnimationSystem.triggerRewardAnimation(rewardData)
  }

  // 🎁 Gérer le clic sur le cadeau
  giftClick(event) {
    event.preventDefault()
    this.triggerExplosion()
  }

  // 💥 Déclencher l'explosion
  triggerExplosion() {
    if (this.hasGiftTarget) {
      this.giftTarget.style.transform = 'scale(1.5)'
      this.giftTarget.style.opacity = '0'
      this.giftTarget.style.transition = 'all 0.3s ease'
    }

    // Créer les effets d'explosion
    this.createConfetti()
    this.createSparkles()
    
    // Afficher le message de félicitations
    setTimeout(() => {
      this.showCongratulations()
    }, 500)
  }

  // 🎊 Créer les confettis
  createConfetti() {
    const confettiContainer = document.createElement('div')
    confettiContainer.className = 'confetti-container'
    confettiContainer.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      pointer-events: none;
      z-index: 10000;
    `

    // Créer 30 confettis
    for (let i = 0; i < 30; i++) {
      const confetti = document.createElement('div')
      confetti.style.cssText = `
        position: absolute;
        width: 10px;
        height: 10px;
        background: ${this.getRandomColor()};
        left: ${Math.random() * 100}%;
        animation: confettiFall ${2 + Math.random() * 2}s linear forwards;
      `
      confettiContainer.appendChild(confetti)
    }

    document.body.appendChild(confettiContainer)

    // Nettoyer après l'animation
    setTimeout(() => {
      document.body.removeChild(confettiContainer)
    }, 5000)
  }

  // ✨ Créer les étincelles
  createSparkles() {
    const sparkleContainer = document.createElement('div')
    sparkleContainer.className = 'sparkle-container'
    sparkleContainer.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      pointer-events: none;
      z-index: 10001;
    `

    // Créer 20 étincelles
    for (let i = 0; i < 20; i++) {
      const sparkle = document.createElement('div')
      sparkle.style.cssText = `
        position: absolute;
        width: 4px;
        height: 4px;
        background: #ffd700;
        border-radius: 50%;
        left: ${Math.random() * 100}%;
        top: ${Math.random() * 100}%;
        box-shadow: 0 0 10px #ffd700;
        animation: sparkleFloat ${1 + Math.random()}s ease-in-out infinite;
      `
      sparkleContainer.appendChild(sparkle)
    }

    document.body.appendChild(sparkleContainer)

    setTimeout(() => {
      document.body.removeChild(sparkleContainer)
    }, 3000)
  }

  // 🎉 Afficher les félicitations
  showCongratulations() {
    const message = document.createElement('div')
    message.className = 'congratulations-message'
    message.style.cssText = `
      position: fixed;
      top: 30%;
      left: 50%;
      transform: translateX(-50%) scale(0);
      z-index: 10002;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px 50px;
      border-radius: 20px;
      font-size: 2rem;
      font-weight: bold;
      text-align: center;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
      border: 3px solid #ffd700;
      animation: messagePop 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55) forwards;
    `

    const rewardData = this.rewardDataValue || {}
    message.innerHTML = `
      <div>🎉 FÉLICITATIONS ! 🎉</div>
      <div style="font-size: 1.5rem; margin-top: 10px; color: #ffd700;">
        ${rewardData.title || 'Récompense Débloquée !'}
      </div>
      <div style="font-size: 1rem; margin-top: 10px; opacity: 0.9;">
        ${rewardData.description || 'Vous avez débloqué une nouvelle récompense !'}
      </div>
    `

    document.body.appendChild(message)

    // Auto-hide après 4 secondes
    setTimeout(() => {
      message.style.opacity = '0'
      message.style.transform = 'translateX(-50%) scale(0.8)'
      message.style.transition = 'all 0.5s ease'
      
      setTimeout(() => {
        document.body.removeChild(message)
      }, 500)
    }, 4000)
  }

  // 🎨 Obtenir une couleur aléatoire
  getRandomColor() {
    const colors = ['#ff6b6b', '#4d9de0', '#6bcf7f', '#ffd93d', '#ff8e8e', '#a855f7']
    return colors[Math.floor(Math.random() * colors.length)]
  }

  // 🧹 Nettoyage
  disconnect() {
    console.log("🎉 Reward Animation Controller disconnected")
  }
}
