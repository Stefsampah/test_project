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
    # Images pour les récompenses ultimes (12 badges) - utiliser asset_path pour Rails
    ultime_images = [
      # Backstage réel
      asset_path('rewards/ultime/backstage_real/backstage_concert_1.jpg'),
      asset_path('rewards/ultime/backstage_real/backstage_concert_2.jpg'),
      asset_path('rewards/ultime/backstage_real/backstage_concert_3.jpg'),
      asset_path('rewards/ultime/backstage_real/backstage_concert_4.jpg'),
      # Invitation concert
      asset_path('rewards/ultime/concert_invitation/concert_stage_1.jpg'),
      asset_path('rewards/ultime/concert_invitation/concert_stage_2.jpg'),
      asset_path('rewards/ultime/concert_invitation/concert_stage_3.jpg'),
      asset_path('rewards/ultime/concert_invitation/concert_stage_4.jpg'),
      # Expérience VIP
      asset_path('rewards/ultime/vip_experience/vip_meeting_1.jpg'),
      asset_path('rewards/ultime/vip_experience/vip_meeting_2.jpg'),
      asset_path('rewards/ultime/vip_experience/vip_meeting_3.jpg'),
      asset_path('rewards/ultime/vip_experience/vip_meeting_4.jpg')
    ]
    
    ultime_images.sample
  end
end
