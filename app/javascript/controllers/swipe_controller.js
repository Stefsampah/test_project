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

    const videoId = this.element.dataset.swipeVideoId
    const playlistId = this.element.dataset.swipePlaylistId
    const gameId = this.element.dataset.swipeGameId

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
      const isSafariMobile = /iPhone|iPad|iPod/.test(navigator.userAgent) && !window.MSStream

      if (response.ok && data.success) {
        if (data.completed) {
          window.location.href = data.redirect || `/playlists/${playlistId}/games/${gameId}/results`
        } else if (data.next_video_id && data.next_video_youtube_id) {
          if (isSafariMobile && typeof window.loadVideoOnSafari === 'function') {
            try {
              window.loadVideoOnSafari(data.next_video_id, data.next_video_youtube_id)
            } catch (e) {
              console.error('loadVideoOnSafari:', e)
              window.location.href = data.redirect || `/playlists/${playlistId}/games/${gameId}`
              return
            }
          } else {
            const iframe = document.querySelector('iframe[id^="youtube-player-"]')
            if (iframe) {
              const baseUrl = window.location.origin
              iframe.src = 'https://www.youtube.com/embed/' + data.next_video_youtube_id +
                '?autoplay=1&controls=0&modestbranding=1&rel=0&playsinline=1&fs=1&disablekb=1' +
                '&iv_load_policy=3&cc_load_policy=0&mute=0&showinfo=0&enablejsapi=1' +
                '&origin=' + encodeURIComponent(baseUrl)
            } else {
              window.location.href = data.redirect || `/playlists/${playlistId}/games/${gameId}`
              return
            }
          }
          this.element.dataset.swipeVideoId = String(data.next_video_id)
          this.isProcessing = false
          buttons.forEach(btn => { btn.disabled = false; btn.style.opacity = '1' })
        } else {
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