import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["badge", "overlay", "content"]

  connect() {
    this.overlayTarget.classList.add("hidden")
  }

  reveal() {
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("animate-fade-in")
    
    setTimeout(() => {
      this.badgeTarget.classList.add("animate-scale-up")
      this.contentTarget.classList.add("animate-slide-up")
    }, 500)
  }

  hide() {
    this.overlayTarget.classList.add("animate-fade-out")
    this.badgeTarget.classList.add("animate-scale-down")
    this.contentTarget.classList.add("animate-slide-down")
    
    setTimeout(() => {
      this.overlayTarget.classList.add("hidden")
      this.overlayTarget.classList.remove("animate-fade-in", "animate-fade-out")
      this.badgeTarget.classList.remove("animate-scale-up", "animate-scale-down")
      this.contentTarget.classList.remove("animate-slide-up", "animate-slide-down")
    }, 500)
  }
} 