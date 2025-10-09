// 🎬 Contrôleur pour gérer les modales YouTube - Tube'NPlay

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "iframe"]
  
  connect() {
    console.log("🎬 YouTube Modal Controller connected")
  }

  // Ouvrir la modale YouTube
  openModal(event) {
    const videoId = event.params.videoId
    const title = event.params.title
    
    if (!videoId) {
      alert('Vidéo non disponible pour le moment')
      return
    }

    // Créer la modale si elle n'existe pas
    let modal = this.modalTarget
    if (!modal) {
      modal = this.createModal()
    }
    
    // Mettre à jour le contenu
    const iframe = modal.querySelector('iframe')
    const titleElement = modal.querySelector('h3')
    
    if (iframe) {
      iframe.src = `https://www.youtube.com/embed/${videoId}?autoplay=1&rel=0&controls=1`
    }
    if (titleElement) {
      titleElement.textContent = title
    }
    
    // Afficher la modale
    modal.style.display = 'block'
    document.body.style.overflow = 'hidden' // Empêcher le scroll
  }

  // Fermer la modale YouTube
  closeModal() {
    const modal = this.modalTarget
    if (modal) {
      modal.style.display = 'none'
      document.body.style.overflow = 'auto' // Rétablir le scroll
      
      // Arrêter la vidéo en vidant la source de l'iframe
      const iframe = modal.querySelector('iframe')
      if (iframe) {
        iframe.src = ''
      }
    }
  }

  // Fermer en cliquant en dehors
  closeOnBackdrop(event) {
    if (event.target === this.modalTarget) {
      this.closeModal()
    }
  }

  // Fermer avec la touche Escape
  closeOnEscape(event) {
    if (event.key === 'Escape') {
      this.closeModal()
    }
  }

  // Créer la modale YouTube
  createModal() {
    const modal = document.createElement('div')
    modal.className = 'youtube-modal'
    modal.style.cssText = `
      display: none;
      position: fixed;
      z-index: 10000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.8);
      backdrop-filter: blur(5px);
    `
    
    modal.innerHTML = `
      <div class="youtube-modal-content" style="
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: #1a1a1a;
        padding: 20px;
        border-radius: 12px;
        max-width: 90vw;
        max-height: 90vh;
        width: 800px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
      ">
        <span class="youtube-modal-close" style="
          position: absolute;
          top: 10px;
          right: 15px;
          color: white;
          font-size: 28px;
          font-weight: bold;
          cursor: pointer;
          z-index: 10001;
        ">&times;</span>
        <h3 style="color: white; margin-bottom: 15px; margin-right: 30px;">Titre de la vidéo</h3>
        <div class="youtube-iframe-container" style="
          position: relative;
          width: 100%;
          height: 0;
          padding-bottom: 56.25%; /* 16:9 aspect ratio */
          background: #000;
          border-radius: 8px;
          overflow: hidden;
        ">
          <iframe style="
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
          " frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
          </iframe>
        </div>
      </div>
    `
    
    // Ajouter les événements
    const closeBtn = modal.querySelector('.youtube-modal-close')
    closeBtn.addEventListener('click', () => this.closeModal())
    
    modal.addEventListener('click', (e) => this.closeOnBackdrop(e))
    
    // Ajouter la modale au DOM
    document.body.appendChild(modal)
    this.modalTarget = modal
    
    return modal
  }

  // Navigation pour les playlists Challenge
  nextVideo() {
    // Cette méthode sera appelée par les boutons de navigation
    // Elle sera implémentée dans les vues spécifiques
    console.log("🎬 Next video requested")
  }

  previousVideo() {
    // Cette méthode sera appelée par les boutons de navigation
    // Elle sera implémentée dans les vues spécifiques
    console.log("🎬 Previous video requested")
  }

  // Méthode pour mettre à jour la vidéo (utilisée par les playlists)
  updateVideo(videoId, title) {
    const modal = this.modalTarget
    if (modal) {
      const iframe = modal.querySelector('iframe')
      const titleElement = modal.querySelector('h3')
      
      if (iframe) {
        iframe.src = `https://www.youtube.com/embed/${videoId}?autoplay=1&rel=0&controls=1`
      }
      if (titleElement) {
        titleElement.textContent = title
      }
    }
  }
}
