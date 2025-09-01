module ApplicationHelper
  def store_image_path(image_name)
    "/assets/store/#{image_name}"
  end
  
  def get_premium_preview_image
    # Images aléatoires pour les récompenses premium (9 badges)
    premium_images = [
      'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia
      'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
      'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
      'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena
      'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
      'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
    ]
    
    premium_images.sample
  end
  
  def get_ultime_preview_image
    # Images pour les récompenses ultimes (12 badges) - temporaire en attendant vos images
    ultime_images = [
      '/assets/images/rewards/ultime/backstage_real/backstage_concert_1.jpg',
      '/assets/images/rewards/ultime/concert_invitation/concert_stage_1.jpg',
      '/assets/images/rewards/ultime/vip_experience/vip_meeting_1.jpg'
    ]
    
    # Pour l'instant, utiliser une image de placeholder en attendant vos vraies images
    ultime_images.sample || 'https://via.placeholder.com/400x300/FF69B4/FFFFFF?text=Ultime+Experience'
  end
end
