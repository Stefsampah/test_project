import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video"]

  connect() {
    console.log("Swipe controller connected")
    // Désactiver les boutons pendant le traitement pour éviter les doubles clics
    this.isProcessing = false
  }

  like() {
    this.handleSwipe(true)
  }

  dislike() {
    this.handleSwipe(false)
  }

  async handleSwipe(liked) {
    // Empêcher les doubles clics
    if (this.isProcessing) {
      console.log("Swipe déjà en cours de traitement")
      return
    }

    const videoId = this.element.dataset.videoId
    const playlistId = this.element.dataset.playlistId
    const gameId = this.element.dataset.gameId

    if (!videoId || !playlistId || !gameId) {
      console.error("Données manquantes pour le swipe", { videoId, playlistId, gameId })
      alert("Erreur : Données manquantes. Veuillez recharger la page.")
      return
    }

    this.isProcessing = true
    // Désactiver visuellement les boutons
    const buttons = this.element.querySelectorAll('.action-btn')
    buttons.forEach(btn => {
      btn.disabled = true
      btn.style.opacity = '0.5'
    })

    try {
      // Utiliser la route SwipesController qui gère mieux les erreurs
      const response = await fetch('/swipes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content || '',
          'Accept': 'application/json'
        },
        credentials: 'same-origin', // Important pour maintenir la session
        body: JSON.stringify({
          video_id: videoId,
          playlist_id: playlistId,
          game_id: gameId,
          liked: liked
        })
      })

      const data = await response.json()

      if (response.ok && data.success) {
        // Succès - rediriger vers la prochaine vidéo ou les résultats
        if (data.completed) {
          // Jeu terminé - rediriger vers les résultats
          window.location.href = data.redirect || `/playlists/${playlistId}/games/${gameId}/results`
        } else {
          // Vidéo suivante - rediriger vers la prochaine vidéo
          window.location.href = data.redirect || `/playlists/${playlistId}/games/${gameId}`
        }
      } else {
        // Erreur - afficher le message et gérer la redirection si nécessaire
        console.error('Erreur lors du swipe:', data.error || 'Erreur inconnue')
        
        if (data.redirect) {
          // Redirection nécessaire (ex: jeu terminé)
          window.location.href = data.redirect
        } else {
          // Erreur récupérable - réactiver les boutons
          this.isProcessing = false
          buttons.forEach(btn => {
            btn.disabled = false
            btn.style.opacity = '1'
          })
          alert(data.error || "Une erreur est survenue. Veuillez réessayer.")
        }
      }
    } catch (error) {
      console.error('Erreur réseau lors du swipe:', error)
      this.isProcessing = false
      buttons.forEach(btn => {
        btn.disabled = false
        btn.style.opacity = '1'
      })
      
      // Vérifier si c'est une erreur de session
      if (error.message.includes('401') || error.message.includes('Unauthorized')) {
        alert("Votre session a expiré. Veuillez vous reconnecter.")
        window.location.href = '/users/sign_in'
      } else {
        alert("Erreur de connexion. Vérifiez votre connexion internet et réessayez.")
      }
    }
  }
} 