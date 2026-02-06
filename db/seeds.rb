# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Création d'un utilisateur admin
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.password = '123456'
    user.admin = true
  end
  
  # Création d'un utilisateur normal
  user = User.find_or_create_by!(email: 'user@example.com') do |user|
    user.password = '234567'
  end
  
puts "✅ Utilisateurs créés"

# ===========================================
# PLAYLISTS POP
# ===========================================

# Playlist Pop 1: Fraîcheur Urbaine vol.1 (Standard)
urban_fresh_playlist = Playlist.find_or_create_by!(title: 'Fraîcheur Urbaine vol.1') do |playlist|
  playlist.description = 'Les nouveaux talents de la pop française'
  playlist.category = 'Pop'
  playlist.save!
    playlist.premium = false
  end
  
urban_fresh_videos = [
  { title: 'Tout Doux', youtube_id: 'LM-qPkGHSaA' },
  { title: 'DO YOU LOVE ME ?', youtube_id: 's1LA-Kmqr04' },
  { title: 'BTRD ft. R2 – Remix', youtube_id: 'QiA_KUkhKp4' },
  { title: 'BANGER', youtube_id: 'SWi-BTsdhEU' },
  { title: 'À l\'Ancienne', youtube_id: '2ho30E5W7Qs' },
  { title: 'En Italie ft. DMA, Nina Palaire', youtube_id: 'kRw-sxRJAJ0' },
  { title: 'Dingue ft. Jungeli', youtube_id: 'i-JAKOrnsws' },
  { title: 'Chemise italienne ft. Vegedream & Youka', youtube_id: 'SNl5SIrdlK8' },
  { title: 'FAUT LAISSER ft. Franglish', youtube_id: 'yQht5eGEBrI' }
]

urban_fresh_videos.each do |video|
  urban_fresh_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
# Playlist Hits 1: Futurs Hits – Pop & Global Vibes vol.1 (Premium)
futurs_hits_playlist = Playlist.find_or_create_by!(title: 'Futurs Hits – Pop & Global Vibes vol.1') do |playlist|
  playlist.description = 'Futurs Hits – Pop & Global Vibes - Volume 1'
  playlist.category = 'Hits'
  playlist.save!
    playlist.premium = true
end

futurs_hits_videos = [
  { title: 'Triangle des Bermudes – Charger', youtube_id: '8p7dQGEkHPk' },
  { title: 'Appelle ta copine', youtube_id: 'gtvQOusc5mQ' },
  { title: 'Dame Un Grrr', youtube_id: 'wHlAnhkLUvw' },
  { title: 'Adriano', youtube_id: 'XyYkPM2THAg' },
  { title: 'Viens on essaie', youtube_id: 'KwvCpirpSgI' },
  { title: 'JUMP', youtube_id: 'CgCVZdcKcqY' },
  { title: 'Y Que Fue?', youtube_id: '16nZ6K7sim4' },
  { title: 'Ruinart', youtube_id: 'e2d9v6dbLHo' },
  { title: 'Back to friends', youtube_id: 'c8zq4kAn_O0' },
  { title: 'Which One', youtube_id: '9-dEHfSCZUQ' }
]

futurs_hits_videos.each do |video|
  futurs_hits_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
# Playlist Hits 2: Futurs Hits – Pop & Global Vibes vol.2 (Premium)
futurs_hits_vol2_playlist = Playlist.find_or_create_by!(title: 'Futurs Hits – Pop & Global Vibes vol.2') do |playlist|
  playlist.description = 'Futurs Hits – Pop & Global Vibes - Volume 2'
  playlist.category = 'Hits'
  playlist.save!
  playlist.premium = true
end

futurs_hits_vol2_videos = [
  { title: 'Just Keep Watching', youtube_id: 'dpvQqmX6SUI' },
  { title: 'Air Force Blanche', youtube_id: 'lPS5VfgKDiU' },
  { title: 'Ginger', youtube_id: 'Hoy5E6bSDZE' },
  { title: 'Believe', youtube_id: 'Ar7ar6ppg-g' },
  { title: 'Whine', youtube_id: 'Gku25G-MrNE' },
  { title: 'Zun Zun', youtube_id: 'MB90ipLdT90' },
  { title: 'Daisies', youtube_id: 'QyvREl7epGY' },
  { title: 'Noventa', youtube_id: '4a67sLrI3EM' },
  { title: 'Love Me Not', youtube_id: 'cswfR85D7jM' },
  { title: 'TaTaTa', youtube_id: 'Uj1g5oumzWY' }
]

futurs_hits_vol2_videos.each do |video|
  futurs_hits_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
# Playlist Pop 2: Indie Français vol.1 (Standard)
indie_francais_vol1_playlist = Playlist.find_or_create_by!(title: 'Indie Français vol.1') do |playlist|
  playlist.description = 'Pop & Indie Francophone 2025'
  playlist.category = 'Pop'
  playlist.save!
    playlist.premium = false
end

indie_francais_vol1_videos = [
  { title: 'Mille vagues', youtube_id: 'jYeMHMCyGRo' },
  { title: 'This Country', youtube_id: '3VTFNxY0cGQ' },
  { title: 'Tout tout', youtube_id: 'qqttfzzT6rU' },
  { title: 'Reine de cœur', youtube_id: 'qS0U_Jf8Q3U' },
  { title: 'Fragile', youtube_id: 'rFkijj7FfR4' },
  { title: 'Toujours les vacances', youtube_id: 'ek8o8-z7hgU' },
  { title: 'Tu me mens', youtube_id: 'LrYzCVsaqrA' },
  { title: 'Allons Voir', youtube_id: 'ykpDVaMHGT4' },
  { title: 'Vinyle', youtube_id: '1umWzAke9D8' },
  { title: 'À deux', youtube_id: '4-FtDa3KYi4' }
]

indie_francais_vol1_videos.each do |video|
  indie_francais_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

# Playlist Pop 3: Indie Français vol.2 (Premium)
indie_francais_vol2_playlist = Playlist.find_or_create_by!(title: 'Indie Français vol.2') do |playlist|
  playlist.description = 'Pop & Indie Francophone 2025 (suite)'
  playlist.category = 'Pop'
  playlist.save!
    playlist.premium = true
end

indie_francais_vol2_videos = [
  { title: 'I Can Do Anything', youtube_id: 'hLv95TyVWYg' },
  { title: 'Rien du tout', youtube_id: 'EabdTJwvuuE' },
  { title: 'Métamorphose', youtube_id: 'PkHBiElDtUs' },
  { title: 'Au secours les vacances', youtube_id: 'IaxtJaWNhLY' },
  { title: 'Sarah Sahara feat. billie', youtube_id: 'g1HzxkoZjuY' },
  { title: 'Pas Bourré', youtube_id: 'y7sXD3e5leE' },
  { title: 'Bouche en Feu', youtube_id: '5B-2_znK_S4' },
  { title: 'Pas Toi', youtube_id: 'XLb4s24L9QI' },
  { title: 'Coups de soleil', youtube_id: 'VspyR320paA' },
  { title: 'Je t\'accuse', youtube_id: 'U3_djdjsI5Q' }
]

indie_francais_vol2_videos.each do |video|
  indie_francais_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
puts "✅ Playlists Pop créées"

# ===========================================
# PLAYLISTS HITS
# ===========================================

puts "✅ Playlists Hits créées"

# ===========================================
# PLAYLISTS AFRO
# ===========================================

# Playlist Afro 1: Afro Vibes Vol. 1 (Standard)
afro_vibes_vol1_playlist = Playlist.find_or_create_by!(title: 'Afro Vibes Vol. 1') do |playlist|
  playlist.description = 'Les meilleures vibes afro du moment'
  playlist.category = 'Afro'
  playlist.save!
  playlist.premium = false
end

afro_vibes_vol1_videos = [
  { title: 'Shatta Confessions', youtube_id: 'qRyBpbJvO8Y' },
  { title: 'Tout Doux', youtube_id: '1A-V7w7lUPM' },
  { title: 'Faut Laisser', youtube_id: 'If23KrW8zLg' },
  { title: 'Ola Oli', youtube_id: 'V4gDbLmVyes' },
  { title: 'Tu sais bien', youtube_id: 'Umgg-ccUSwc' },
  { title: 'Whine & Kotch x Jealousy', youtube_id: 'bXt-oW8bi6s' },
  { title: 'C\'est Dosé', youtube_id: 'lvCCqkkweyw' }
]

afro_vibes_vol1_videos.each do |video|
  afro_vibes_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
# Playlist Afro 2: Afro Vibes Vol. 2 (Premium)
afro_vibes_vol2_playlist = Playlist.find_or_create_by!(title: 'Afro Vibes Vol. 2') do |playlist|
  playlist.description = 'Suite des meilleures vibes afro'
  playlist.category = 'Afro'
  playlist.save!
    playlist.premium = true
end

afro_vibes_vol2_videos = [
  { title: 'Que Pasa ?', youtube_id: 'h1VBV1Ad_Xw' },
  { title: 'Trop d\'amour', youtube_id: '2eyhtt9fZwg' },
  { title: 'C\'est mon BB', youtube_id: 'KbJpNjr0Pow' },
  { title: 'Naza - Appelle les pompiers', youtube_id: 'AycI9MTlkQU' },
  { title: 'PAY!', youtube_id: 'wnLFntG-jvY' },
  { title: 'Chouchou', youtube_id: '-zAJdi_YsjM' },
  { title: 'Bodycount', youtube_id: '806RIqM5NbM' },
  { title: 'Joke', youtube_id: 'h5qJFrBAecc' },
  { title: 'Bukki', youtube_id: 'qmAY_v9djbg' },
  { title: 'Choix', youtube_id: 'B2L_RscvTfo' }
]

afro_vibes_vol2_videos.each do |video|
  afro_vibes_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
# Playlist Afro 3: Afro Vibes Vol. 3 (Premium)
afro_vibes_vol3_playlist = Playlist.find_or_create_by!(title: 'Afro Vibes Vol. 3') do |playlist|
  playlist.description = 'Final des meilleures vibes afro'
  playlist.category = 'Afro'
  playlist.save!
    playlist.premium = true
end

afro_vibes_vol3_videos = [
  { title: 'Simba', youtube_id: 'qvVGbUWorUo' },
  { title: 'Ça m\'a laissé', youtube_id: 'qrdK1RqpcV0' },
  { title: 'À Tes Côtés', youtube_id: 'nczf50Gh_pM' },
  { title: 'Pas Jalouse', youtube_id: 'vCRztEFJc50' },
  { title: 'YORSSY Ft. GUY2BEZBAR - MALABAR', youtube_id: 'wqXe3DrJrF0' },
  { title: 'Faux Pas', youtube_id: 'eoykXiyvB2I' },
  { title: 'ZALA', youtube_id: 'MokYNrCNh-4' },
  { title: 'Changer Camp', youtube_id: '8xwUCf2qz_s' },
  { title: 'ATASSA', youtube_id: 'bxLvdwgRZvI' }
]

afro_vibes_vol3_videos.each do |video|
  afro_vibes_vol3_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
puts "✅ Playlists Afro créées"

# ===========================================
# PLAYLISTS ELECTRO
# ===========================================

# Playlist Electro 1: Électrons libres Vol. 1 (Standard)
electrons_libres_vol1_playlist = Playlist.find_or_create_by!(title: 'Électrons libres Vol. 1') do |playlist|
  playlist.description = 'Electro & Chill Vibes 2025'
  playlist.category = 'Electro'
  playlist.save!
  playlist.premium = false
end

electrons_libres_vol1_videos = [
  { title: 'Dream Night', youtube_id: 'SITfpgTCix8' },
  { title: 'Vaitimbora', youtube_id: 'jOwsX8AAFx8' },
  { title: 'Crazy For It', youtube_id: '7q8mnv5uZpQ' },
  { title: 'One Mind', youtube_id: 'EpXzXFPXvfo' },
  { title: 'take me by the hand', youtube_id: 'jdU16tnrt14' },
  { title: 'Kimpton', youtube_id: 'dpSUbK-bOLA' },
  { title: 'A Girl Like You', youtube_id: 'XGEhFOnEJ84' },
  { title: 'Toute Première Fois', youtube_id: 'G-EWrKUHxZ4' },
  { title: 'FREE', youtube_id: 'JYCuHUaOk28' },
  { title: 'Everytime We Touch', youtube_id: 'B8qQXQkwQ3c' }
]

electrons_libres_vol1_videos.each do |video|
  electrons_libres_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

# Playlist Electro 2: Électrons libres Vol. 2 (Premium)
electrons_libres_vol2_playlist = Playlist.find_or_create_by!(title: 'Électrons libres Vol. 2') do |playlist|
  playlist.description = 'Suite Electro & Chill Vibes'
  playlist.category = 'Electro'
  playlist.save!
    playlist.premium = true
  end
  
electrons_libres_vol2_videos = [
  { title: 'I Started A Fire', youtube_id: 'bthFcQOhQxY' },
  { title: 'Runaway', youtube_id: 'P9RFU4ENucM' },
  { title: 'I Never Party in Paris', youtube_id: 'SQ1HbA5rq44' },
  { title: 'Resonances From The D', youtube_id: 'y5NQESpKm8s' },
  { title: 'Morning Bliss', youtube_id: 'ejezLDkLtNU' },
  { title: 'Dior', youtube_id: 'qXnqZo03PHY' },
  { title: 'Unforgettable', youtube_id: 'IdBIdmi0k18' },
  { title: 'Blessings', youtube_id: '_okjhzBpdU0' },
  { title: 'MAD', youtube_id: 'LvUtS-btnyU' },
  { title: 'Your River (Live)', youtube_id: 'Iau61g36Nb4' }
]

electrons_libres_vol2_videos.each do |video|
  electrons_libres_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

puts "✅ Playlists Electro créées"

# ===========================================
# PLAYLISTS REGGAE/DANCEHALL
# ===========================================

# Playlist Reggae 1: Dancehall & Island Vibes Vol. 1 (Standard)
dancehall_vol1_playlist = Playlist.find_or_create_by!(title: 'Dancehall & Island Vibes Vol. 1') do |playlist|
  playlist.description = 'Les meilleures vibes dancehall et caribéennes'
  playlist.category = 'Reggae'
  playlist.save!
  playlist.premium = false
end

dancehall_vol1_videos = [
  { title: 'The Greatest Band Ever', youtube_id: 'FgBmxD9JwKg' },
  { title: 'Shake It To The Max', youtube_id: 'UjBhbMMgLzc' },
  { title: 'Passenger Princess', youtube_id: 'Lk9wx5RoLLs' },
  { title: 'DADA', youtube_id: 'lyogHC6UwlI' },
  { title: 'Rich Mean Man', youtube_id: '2wkkg7wy29Y' },
  { title: 'Rich Sew', youtube_id: '9XA-u1C9OoM' },
  { title: 'NY Girls', youtube_id: 's_y6JT097Q8' },
  { title: 'All Over the World', youtube_id: 'dPmuBVhKAWQ' },
  { title: 'Toxic', youtube_id: 'uKgyeojpbqw' },
  { title: 'Pretty Rockstar', youtube_id: '5ye4qj0z3Do' }
]

dancehall_vol1_videos.each do |video|
  dancehall_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
# Playlist Reggae 2: Dancehall & Island Vibes Vol. 2 (Premium)
dancehall_vol2_playlist = Playlist.find_or_create_by!(title: 'Dancehall & Island Vibes Vol. 2') do |playlist|
  playlist.description = 'Suite des vibes dancehall et caribéennes'
  playlist.category = 'Reggae'
  playlist.save!
  playlist.premium = true
end

dancehall_vol2_videos = [
  { title: 'Ba Ba Bad', youtube_id: 'FszlG-KIRnM' },
  { title: '4 Kampé', youtube_id: 'Srvt_6up-0o' },
  { title: 'Taliban (Spaceship Billy Amapiano Mix)', youtube_id: 'tRTDPMl7u1g' },
  { title: 'Praise Jah in the Moonlight', youtube_id: 'iD__IJWqwY8' },
  { title: 'Push 2 Start', youtube_id: 'uLK2r3sG4lE' },
  { title: 'Wild n Rich', youtube_id: 'O1PZ2Cu_9RM' },
  { title: 'Hit and Run', youtube_id: 'rJwEphsNVH8' },
  { title: '8:00 PM', youtube_id: 'ywackFGQNZQ' },
  { title: 'Big Breeze', youtube_id: 'Yo3QyiD28Dc' },
  { title: 'Bouwey', youtube_id: 'tW8KrbpTXcI' }
]

dancehall_vol2_videos.each do |video|
  dancehall_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Reggae 3: Dancehall & Island Vibes Vol. 3 (Premium)
dancehall_vol3_playlist = Playlist.find_or_create_by!(title: 'Dancehall & Island Vibes Vol. 3') do |playlist|
  playlist.description = 'Final des vibes dancehall et caribéennes'
  playlist.category = 'Reggae'
  playlist.save!
  playlist.premium = true
end

dancehall_vol3_videos = [
  { title: 'Whites', youtube_id: '2C0mGEfQnt4' },
  { title: 'Dating Szn', youtube_id: 'eUePmZFIXUg' },
  { title: 'Balance', youtube_id: 'HSlhZfpnRZM' },
  { title: 'Know About Dat', youtube_id: 'aROcMsnbCOc' },
  { title: 'GO GO', youtube_id: 'WqwrIFzIpBg' },
  { title: 'V6', youtube_id: 'B3suf-jqG1U' },
  { title: 'Rum Behavior', youtube_id: 'JzV6K1yi5vo' },
  { title: 'Top Tier', youtube_id: '1vZKxKJvJ9g' },
  { title: 'Mad Out', youtube_id: 'KxYgGzJvL9o' },
  { title: 'Pressure', youtube_id: 'ZpYgNzJgK9w' }
]

dancehall_vol3_videos.each do |video|
  dancehall_vol3_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

puts "✅ Playlists Reggae/Dancehall créées"

# ===========================================
# PLAYLISTS ROCK
# ===========================================

# Playlist Rock 1: Nouveautés Rock vol.1 (Standard)
rock_vol1_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Rock vol.1') do |playlist|
  playlist.description = 'Les dernières nouveautés rock'
  playlist.category = 'Rock'
  playlist.save!
  playlist.premium = false
end

rock_vol1_videos = [
  { title: 'Do Me Like That', youtube_id: 'ocJWc7DgGp8' },
  { title: 'Hollywood Forever', youtube_id: '0trg8w9Wtsw' },
  { title: 'Up From The Bottom', youtube_id: '97Mj6pXYMd8' },
  { title: 'Heavy Is The Crown', youtube_id: '5FrhtahQiRc' },
  { title: 'Afterlife', youtube_id: 'mTduyC2zPXg' },
  { title: 'Eyes Closed', youtube_id: 'v08qmr8m_-w' },
  { title: 'Lovesick Lullaby', youtube_id: 'WfwUrz7s_Vg' },
  { title: 'HONEY (ARE U COMING?)', youtube_id: 'HZnNt9nnEhw' },
  { title: 'The Emptiness Machine', youtube_id: 'SRXH9AbT280' },
  { title: 'Wake Up', youtube_id: 'q392mSz4VeY' }
]

rock_vol1_videos.each do |video|
  rock_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Rock 2: Nouveautés Rock vol.2 (Premium)
rock_vol2_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Rock vol.2') do |playlist|
  playlist.description = 'Suite des nouveautés rock'
  playlist.category = 'Rock'
  playlist.save!
  playlist.premium = true
end

rock_vol2_videos = [
  { title: 'Watch The World Burn', youtube_id: 'qMXESlny4-I' },
  { title: 'DArkSide', youtube_id: '3Nt37RGbVjo' },
  { title: 'Outta My Head', youtube_id: 'z7mAqJE2sHo' },
  { title: 'Ash In The Wind', youtube_id: '_A571q0YbhQ' },
  { title: 'The Funeral', youtube_id: '02T6xLNXEE0' },
  { title: 'Mary On A Cross', youtube_id: 'k5mX3NkA7jM' },
  { title: 'Believer', youtube_id: '7wtfhZwyrcc' },
  { title: 'Mayday', youtube_id: 'o5hWEa1w6Z8' },
  { title: 'Two Faced', youtube_id: 'kivUsDGWojU' },
  { title: 'Prequel', youtube_id: 'hX0lhueeib8' }
]

rock_vol2_videos.each do |video|
  rock_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Rock 3: Nouveautés Rock vol.3 (Premium)
rock_vol3_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Rock vol.3') do |playlist|
  playlist.description = 'Final des nouveautés rock'
  playlist.category = 'Rock'
  playlist.save!
  playlist.premium = true
end

rock_vol3_videos = [
  { title: 'WONDERWaLL', youtube_id: 'pwYCbAsF3EI' },
  { title: 'Take Me To The Beach', youtube_id: '5Duje_sZko8' },
  { title: 'Favour', youtube_id: 'HjSF2cpDU8s' },
  { title: 'Taxi', youtube_id: 'sqFickrNDrk' },
  { title: 'maybe', youtube_id: '9xht4JIOfjU' },
  { title: 'OFF MY FACE', youtube_id: '8n4S1-ctsZw' },
  { title: 'Top 10 statues that cried blood', youtube_id: 'LxxlN_FhLac' },
  { title: 'Woman on the Moon', youtube_id: '2wI64khXXQw' },
  { title: 'Navigating', youtube_id: '07YtBj3BEBQ' },
  { title: 'Somebody Else', youtube_id: 'bjJdqpHDwq8' }
]

rock_vol3_videos.each do |video|
  rock_vol3_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

puts "✅ Playlists Rock créées"

# ===========================================
# PLAYLISTS RAP
# ===========================================

# Playlist Rap 1: Nouveautés Rap Vol.1 (Standard)
hiphop_vol1_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Rap Vol.1') do |playlist|
  playlist.description = 'Les dernières nouveautés rap'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = false
end

hiphop_vol1_videos = [
  { title: 'Young Black & Rich', youtube_id: 'F3qWBh7jZZ0' },
  { title: 'They Wanna Have Fun', youtube_id: 'Hvv2tLVQ78E' },
  { title: 'Bodies', youtube_id: '_hkoMopfRJU' },
  { title: 'just say dat', youtube_id: '8gy-Y9tWK6M' },
  { title: 'Blocked on Ig', youtube_id: 'juH9D8wUriY' },
  { title: 'Cant Go Broke (Remix)', youtube_id: 'OkB-pO74XK8' },
  { title: 'Blow My High', youtube_id: '1Me0CGJXNqI' },
  { title: 'Outside', youtube_id: 'QTbQMfWxZu8' },
  { title: 'Clap', youtube_id: '1MSap_AkGOM' },
  { title: 'forever be mine (feat. Wizkid)', youtube_id: 'jBaL41mKS8U' }
]

hiphop_vol1_videos.each do |video|
  hiphop_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Rap 2: Nouveautés Rap Vol.2 (Premium)
hiphop_vol2_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Rap Vol.2') do |playlist|
  playlist.description = 'Suite des nouveautés rap'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

hiphop_vol2_videos = [
  { title: 'WHERE WAS YOU', youtube_id: 'um-uRGkT8GU' },
  { title: 'Somebody', youtube_id: 'qB7kLilZWwg' },
  { title: 'BAND4BAND', youtube_id: 'pDddlvCfTiw' },
  { title: 'Trunks (From "Highest 2 Lowest")', youtube_id: 'IN1Tbi7PRJQ' },
  { title: 'NO COMMENTS', youtube_id: '5A_NqVSl1DQ' },
  { title: 'tv off', youtube_id: 'U8F5G5wR1mk' },
  { title: 'Planet Out', youtube_id: 'g3GpuKkqaYE' },
  { title: 'I Might Be', youtube_id: 'ig3EDX_i0r4' },
  { title: 'STOP PLAYING WITH ME', youtube_id: 'VpzPzFQVPK8' },
  { title: 'WHATCHU KNO ABOUT ME', youtube_id: 'wyzSmQPuCJ0' }
]

hiphop_vol2_videos.each do |video|
  hiphop_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Rap 3: Nouveautés Rap Vol.3 (Premium)
hiphop_vol3_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Rap Vol.3') do |playlist|
  playlist.description = 'Final des nouveautés rap'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

hiphop_vol3_videos = [
  { title: 'WHAT DID I MISS', youtube_id: 'Lx4gPURH35g' },
  { title: 'Chicken Grease', youtube_id: '_gf3bkP6B4U' },
  { title: 'Like That', youtube_id: 'N9bKBAA22Go' },
  { title: 'Identity Theft', youtube_id: 'f2B4Zn2N7kI' },
  { title: 'NOKIA', youtube_id: '8ekJMC8OtGU' },
  { title: 'All The Way', youtube_id: '7kyHvPNbugk' },
  { title: 'Touch Down', youtube_id: 'pRt6cCpGaBU' },
  { title: 'Ring Ring Ring', youtube_id: 'U85bOgG7DWM' },
  { title: 'Finest', youtube_id: 'vJJ7Yt-uqJE' },
  { title: 'Type Shit', youtube_id: 'I0fgkcTbBoI' }
]

hiphop_vol3_videos.each do |video|
  hiphop_vol3_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

puts "✅ Playlists Rap créées"

# ===========================================
# PLAYLISTS AFRO RAP IVOIRIENNES
# ===========================================

# Playlist Afro Rap 1: Afro Rap (Standard)
afro_rap_playlist = Playlist.find_or_create_by!(title: 'Afro Rap') do |playlist|
  playlist.description = 'Un mix équilibré de rap ivoirien moderne avec des sonorités futuristes'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = false
end

afro_rap_videos = [
  { title: 'HIMRA - NUMBER ONE (FT. MINZ)', youtube_id: 'b16_UBiP4G0' },
  { title: 'Didi B - GO feat @jrk1912', youtube_id: 'I-_YDWMXTv0' },
  { title: 'ZOH CATALEYA - TOURA DRILL 1', youtube_id: 'kT5PHa0fov8' },
  { title: 'Didi B - DX3 feat MHD', youtube_id: '3madRVVh00I' },
  { title: 'Bignyne Wiz - Haut Niveau', youtube_id: 'gzGL4RD9IZs' },
  { title: 'Didi B - Fatúmata feat Naira Marley', youtube_id: '2HxJ1R8_xV4' },
  { title: 'HIMRA - ÇA GLOW', youtube_id: 'qj5IjESRaxI' },
  { title: 'Didi B - Rockstxr', youtube_id: 'YeCRoOnr5vU' },
  { title: 'SINDIKA x DIDI B - RODELA', youtube_id: 'YCSbp-oTnyc' },
  { title: 'Didi B - 2025 (Official Music Video)', youtube_id: 'yzWENpeiZzc' }
]

afro_rap_videos.each do |video|
  afro_rap_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Afro Rap 2: Afro Trap (Standard)
afro_trap_playlist = Playlist.find_or_create_by!(title: 'Afro Trap') do |playlist|
  playlist.description = 'Les meilleurs sons trap et street du rap ivoirien'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = false
end

afro_trap_videos = [
  { title: 'Wilzo - Pression', youtube_id: 'MXVL9vdiEUg' },
  { title: 'HIMRA x PHILIPAYNE - FREESTYLE DRILL IVOIRE #4', youtube_id: 'OvIWDW10GhI' },
  { title: 'BMUXX CARTER - 24H CHRONO (FT. DIDI B)', youtube_id: 'LQhTtxfmxAU' },
  { title: 'TRK ft DOPELYM - AMINA', youtube_id: 'iEIuKUcTaTc' },
  { title: 'SINDIKA - BOYAUX', youtube_id: '47DZRLGvN7I' },
  { title: 'AMEKA ZRAI - AKO CÉLÉBRATE', youtube_id: 'q4y4A-YbgGY' },
  { title: 'Toto Le Banzou & AriiSiguira - Attiéké', youtube_id: 'ZfPQxHDqkIU' },
  { title: 'Salima Chica - Songi Songi (Dj Babs)', youtube_id: '4qlsQ95Q_nE' },
  { title: 'SOKEÏ - ASSEHOMAPOU', youtube_id: 'CFNcg_MoyPc' },
  { title: 'LEPAPARA x PAKI CHENZU - BAGAVATHI / CARDIO', youtube_id: 'utCXpnYBQSY' }
]

afro_trap_videos.each do |video|
  afro_trap_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Afro Rap 3: Rap Ivoire Power (Standard)
rap_ivoire_power_playlist = Playlist.find_or_create_by!(title: 'Rap Ivoire Power') do |playlist|
  playlist.description = 'Des sons apaisants et mélodiques pour se détendre'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = false
end

rap_ivoire_power_videos = [
  { title: 'GAWA – Lesky', youtube_id: 'uQjVJKBrGHo' },
  { title: 'À Toi – Socé', youtube_id: 'fDnY4Bz-ttY' },
  { title: 'Foua (C\'est Facile) – Miedjia', youtube_id: 'zdMS4wZxXIs' },
  { title: 'Il sait – Leufa', youtube_id: '-LwHX5Nndcw' },
  { title: 'Pleure – Le JLO & Ameka Zrai', youtube_id: '4QLNn0BHjHs' },
  { title: 'Béni – Lesky', youtube_id: '2vQhkQiPSoA' },
  { title: 'Tu dis quoi – Kadja', youtube_id: 's5zPAbaiZx4' },
  { title: 'De Même – Miedjia', youtube_id: 'G-sK6B0GKIo' },
  { title: 'BlackArtist – Albinny', youtube_id: 'RQQJfCK-_EY' },
  { title: 'Si C\'est Pas Dieu – Kawid', youtube_id: '1_rhXT_4TMU' }
]

rap_ivoire_power_videos.each do |video|
  rap_ivoire_power_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Afro Rap 4: Flow Rap Afro (Premium)
flow_rap_afro_playlist = Playlist.find_or_create_by!(title: 'Flow Rap Afro') do |playlist|
  playlist.description = 'Des flows exceptionnels dans des ambiances uniques'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

flow_rap_afro_videos = [
  { title: 'HIMRA – G3N3RATION N3RF ft. Kerchak', youtube_id: 'o3eRvNoPK80' },
  { title: 'Widgunz – Ma girlfriend ft. Chrystel', youtube_id: '2GYAsAl8XG0' },
  { title: 'Tripa Gninnin – Kirikou', youtube_id: 'UOfrbereOFE' },
  { title: 'Kadja – Les Meilleurs', youtube_id: 'FsfwYxEmxQw' },
  { title: 'Fireman - Yeyeye', youtube_id: 'B1wbe2zfhRY' },
  { title: 'Tripa Gninnin – C 1 JEU', youtube_id: 'DjM1GVoa5E8' },
  { title: 'Suspect 95 – LE PARTI 2', youtube_id: 'SgPVwm9HCko' },
  { title: 'J-Haine – MARASSE', youtube_id: 'RhyiJQ8H7Fg' },
  { title: 'HIMRA – Freestyle Drill Ivoire #5', youtube_id: 'GyIDTBHEOAQ' },
  { title: 'Suspect 95 – HOLYGHOST', youtube_id: '8fOuA6V31YU' }
]

flow_rap_afro_videos.each do |video|
  flow_rap_afro_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Afro Rap 5: Urban Rap Afro (Premium)
urban_rap_afro_playlist = Playlist.find_or_create_by!(title: 'Urban Rap Afro') do |playlist|
  playlist.description = 'Les meilleures punchlines et sons street du rap ivoirien'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

urban_rap_afro_videos = [
  { title: 'PHILIPAYNE – Ils Disent Quoi', youtube_id: 'mPT2Kf6c6Eg' },
  { title: 'Black K – TITI FLY3#', youtube_id: 'sEtuJ5ZX6_g' },
  { title: 'Elow\'n – BPC Freestyle', youtube_id: 'cO3WEw7RQUg' },
  { title: 'NAS ft. Didi B, Sindika, Dopelym… – BENI', youtube_id: 'oWIskZqDf_U' },
  { title: 'Santé Ameka Zrai', youtube_id: '81XXS8HunSs' },
  { title: 'HIMRA – BÂTON NON NON', youtube_id: '3Eiq6mv8Vlo' },
  { title: 'AMEKA ZRAI X @DidiBKiffnobeatTV', youtube_id: 't6zqvWpMKcE' },
  { title: 'Black K – LAAARGE FLY1#', youtube_id: 'ZHiejZVpvgQ' },
  { title: 'DIDI B - PADRÉ VELI / VODOO FREESTYLE', youtube_id: '8yQv8iXGg5o' },
  { title: 'Suspect 95 – META VOL.2', youtube_id: 'Z7sbpd4fLyE' }
]

urban_rap_afro_videos.each do |video|
  urban_rap_afro_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Afro Rap 6: Afro Flow (Premium)
afro_flow_playlist = Playlist.find_or_create_by!(title: 'Afro Flow') do |playlist|
  playlist.description = 'Les flows les plus techniques et punchlines les plus percutantes'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

afro_flow_videos = [
  { title: 'Lograndvic – Trap Djou 2', youtube_id: 'V3HR6P4xb8k' },
  { title: 'Tripa Gninnin – Dans l\'eau (Freestyle Gninnin 2)', youtube_id: '8y-iUrYrHT4' },
  { title: 'Kadja – Freestyle KORDIAL 2', youtube_id: 'bZkMs9bHpi4' },
  { title: 'Black K & Fior 2 Bior – Tu veux gâter', youtube_id: 'WdcJn_O-tVM' },
  { title: 'SINDIKA – Boyaux', youtube_id: 'rZfxarZ2Wvw' },
  { title: 'Tripa Gninnin feat Latop – Pourquoi tu gnan', youtube_id: 'X0OeoOqwT3M' },
  { title: 'MIEDJIA - MA CHERIE', youtube_id: 'P5rMrK1rzAg' },
  { title: 'SaintDusty - 225', youtube_id: 'YisOCtN0B0s' },
]

afro_flow_videos.each do |video|
  afro_flow_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Afro Rap 7: Afro Melow (Premium)
afro_melow_playlist = Playlist.find_or_create_by!(title: 'Afro Melow') do |playlist|
  playlist.description = 'Un mélange unique de drill, street et mélodie'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

afro_melow_videos = [
  { title: 'Black K, Fior 2 Bior - Tu veux gâter', youtube_id: 'dREDKBQ_nuM' },
  { title: 'Lil Jay Bingerack – Espoir', youtube_id: 'rJvZxWlKZgQ' },
  { title: 'D14 – Roule', youtube_id: 'ZK8vY7Jkz9g' },
  { title: 'J-Haine – Position ft. Himra', youtube_id: 'XkzvBvUuJ9M' },
  { title: 'HIMRA – BADMAN GANGSTA ft. Jeune Morty', youtube_id: 'gYzWvX3pJkE' },
  { title: 'Widgunz – My Bae ft. Himra', youtube_id: 'TqWvLz9KpXo' },
  { title: 'Tripa Gninnin – Decapo', youtube_id: 'YpLzKx8WvJg' },
  { title: 'Kadja – Le Roi', youtube_id: 'MvXqLp9JzKf' },
  { title: 'Albinny – Attaque à 2', youtube_id: 'JvKxWz8LpQo' },
  { title: 'Tripa Gninnin – Ça va vite', youtube_id: 'LpXvJz9KqWg' }
]

afro_melow_videos.each do |video|
  afro_melow_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

puts "✅ Playlists Afro Rap créées"

# ===========================================
# PLAYLISTS RAP IVOIRE SUPPLEMENTAIRES
# ===========================================

# Playlist Rap La Relève vol.1 (Standard)
rap_releve_vol1_playlist = Playlist.find_or_create_by!(title: 'Rap La Relève vol.1') do |playlist|
  playlist.description = 'La nouvelle génération du rap français'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = false
end

rap_releve_vol1_videos = [
  { title: '4h44', youtube_id: 'QbgdoKDZA0Y' },
  { title: 'BOTTEGA', youtube_id: 'j0rrbBXnIMc' },
  { title: 'Biff pas d\'love', youtube_id: 'TDO0GRay2fQ' },
  { title: 'COMMENT CA VA', youtube_id: 'qvmR57nwBPc' },
  { title: 'Célibataire', youtube_id: '_xuNmoJEoIM' },
  { title: 'Jaloux (feat. JUL)', youtube_id: 'j6P8RLRtU9I' },
  { title: 'P.I.B', youtube_id: 'uQB1ZdEd2CM' },
  { title: 'Poukwa (elle m\'demande)', youtube_id: 'rAxVxcxuLnM' },
  { title: 'Putana', youtube_id: 'uuRvS4wzrHA' },
  { title: 'Terrain', youtube_id: 'RsBD1POgx-c' }
]

rap_releve_vol1_videos.each do |video|
  rap_releve_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Rap La Relève vol.2 (Premium)
rap_releve_vol2_playlist = Playlist.find_or_create_by!(title: 'Rap La Relève vol.2') do |playlist|
  playlist.description = 'La nouvelle génération du rap français - Volume 2'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

rap_releve_vol2_videos = [
  { title: 'Attack ft. Himra', youtube_id: 'foq514nlWXw' },
  { title: 'BUSINESSMAN', youtube_id: '1Zs6Wa3LvTM' },
  { title: 'David Douillet ft. IDS x SDM', youtube_id: 'CiAlc1mT62Q' },
  { title: 'Elle 2.0', youtube_id: 'JKXYAWruyQo' },
  { title: 'Génération Foirée', youtube_id: 'LcwR4kxs38I' },
  { title: 'ISACK HADJAR ft. 2ZES', youtube_id: 'BEGoWGQrcBU' },
  { title: 'La Zone', youtube_id: 'nIcDZNZGXjI' },
  { title: 'Le P\'tit', youtube_id: '0-p3Z1oqFzA' },
  { title: 'Nagasaki', youtube_id: 'UrXt7YC0-VI' },
  { title: 'Tunnel ft. JRK 19', youtube_id: 'W33jLp-m0-Q' }
]

rap_releve_vol2_videos.each do |video|
  rap_releve_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Drill Rap Afro (Premium)
drill_rap_afro_playlist = Playlist.find_or_create_by!(title: 'Drill Rap Afro') do |playlist|
  playlist.description = 'Les meilleurs freestyles et sons drill de la scène ivoirienne'
  playlist.category = 'Rap'
  playlist.save!
  playlist.premium = true
end

drill_rap_afro_videos = [
  { title: '3XDAVS ft. Didi B – BODOINGADAI', youtube_id: 'uhoIdYPVcfc' },
  { title: 'FAMATITUDE', youtube_id: 'b9RWN_IVSZw' },
  { title: 'Black K – NO NO NO', youtube_id: 'eJcqB_XaOVM' },
  { title: 'D14 – DAGBACHI ft. Shado Chris & JM', youtube_id: 'tI56ZeTearo' },
  { title: 'Didi B – Forcement', youtube_id: 'PXnjCEpP9rE' },
  { title: 'Elow\'n – Piégé', youtube_id: 'gcrisZnEztU' },
  { title: 'Pour Toujours', youtube_id: 'YFopkv9rjF0' },
  { title: 'J-Haine – CAMELEON', youtube_id: 'geHi7DmvE7g' },
  { title: 'Lil Jay Bingerack – 15500 VOLTS', youtube_id: 'B39sdzpWnTI' },
  { title: 'PHILIPAYNE – Contrat x Himra', youtube_id: 'ypXaXwE0Yq4' }
]

drill_rap_afro_videos.each do |video|
  drill_rap_afro_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Playlist Afro Vibes (Premium) - Version alternative
afro_vibes_premium_playlist = Playlist.find_or_create_by!(title: 'Afro Vibes') do |playlist|
  playlist.description = 'Un mélange éclectique d\'ambiances et de styles variés'
  playlist.category = 'Afro'
  playlist.save!
  playlist.premium = true
end

afro_vibes_premium_videos = [
  { title: 'GAMME 2 BOSS – Lil Jay Bingerack ft. @loiseaurare8g', youtube_id: 'hqH3EG88x2A' },
  { title: 'BEURRE – TC', youtube_id: 'yGCK_59VVM0' },
  { title: 'ALLô ALLô – LE COUTEAU, 3XDAVS', youtube_id: 'x9wYUd8MJqU' },
  { title: 'Dans Dos – Akim Papichulo', youtube_id: '_pYzyRrXM0o' },
  { title: 'JOSEY - Le Monde Est à Nous (Official Music Video)', youtube_id: 'AzKUqSNSU5Y' },
  { title: 'Kedjevara - ça fait mal (Clip Officiel)', youtube_id: 'gcpq4wDm9gM' },
  { title: 'LOYANN09 - GATER', youtube_id: 'ISp2PHAYSw4' },
  { title: 'MATA CRAZY KPALO – Sokeï', youtube_id: 'WaABvOJnq_Y' },
  { title: 'MOUMENT – Boykito', youtube_id: 'YzTHnIVDOHI' },
  { title: 'PAKI CHENZU - KIRA 5', youtube_id: 'c00T_ywXmo4' }
]

afro_vibes_premium_videos.each do |video|
  afro_vibes_premium_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

puts "✅ Playlists Rap Ivoire supplémentaires créées"

# ===========================================
# PLAYLIST RELEASED VOL.1
# ===========================================

# Playlist Released: RELEASED vol.1 (Standard)
released_vol1_playlist = Playlist.find_or_create_by!(title: 'RELEASED vol.1') do |playlist|
  playlist.description = 'Nouveautés Pop, Rap & R&B 2025'
  playlist.category = 'Pop'
  playlist.save!
  playlist.premium = false
end

released_vol1_videos = [
  { title: 'A Little More', youtube_id: 'O_0Wn73AnC8' },
  { title: 'Gucci Gucci', youtube_id: 'h4u_QJsvoX0' },
  { title: 'Soap (feat. PinkPantheress)', youtube_id: 'dtzHH4hpKc8' },
  { title: 'Lunettes quartier // 2025', youtube_id: 'uN08LRMD0-A' },
  { title: 'Things I Haven\'t Told You', youtube_id: 'PFZKmdpbGp0' },
  { title: 'Malembe', youtube_id: 'a9GeotvTA4s' },
  { title: 'Just Say Dat', youtube_id: 'zDkUDVK_eeA' },
  { title: 'Holy Water', youtube_id: '4wMNUOnH514' },
  { title: 'No Sharing ft. Luh Tyler', youtube_id: 'eLyYDgjMxr0' },
  { title: 'Ugly', youtube_id: 'OLavHL4NJ08' }
]

released_vol1_videos.each do |video|
  released_vol1_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

puts "✅ Playlist RELEASED vol.1 créée"

# ===========================================
# PLAYLIST RELEASED VOL.2
# ===========================================

# Playlist Released: RELEASED vol.2 (Standard)
released_vol2_playlist = Playlist.find_or_create_by!(title: 'RELEASED vol.2') do |playlist|
  playlist.description = 'Nouveautés Pop, Rap & R&B 2025'
  playlist.category = 'Pop'
  playlist.save!
  playlist.premium = false
end

released_vol2_videos = [
  { title: 'Si tu pars', youtube_id: '0Rl8lrbCyKM' },
  { title: 'Loved You Better ft. Dean Lewis', youtube_id: '2XGO7NWwbnU' },
  { title: 'Arrêt de bus ft. Niska', youtube_id: 'XwN54DkXJno' },
  { title: 'Gabriela (Young Miko Remix)', youtube_id: 'rXU7je1_Ons' },
  { title: 'Vanessa Paradis - Bouquet final', youtube_id: '4is-XrHM6RY' },
  { title: 'Other Side of Love', youtube_id: 'S76hEZ7nHN0' },
  { title: 'Grand-mère', youtube_id: 'lgdWKEtrBaU' },
  { title: 'Vampire Bat', youtube_id: 'H4hyhP-Dguw' },
  { title: 'Fineshyt', youtube_id: 'shRJSgx48es' },
  { title: 'NO CAP', youtube_id: 'Q4kCS4u9b8' },
  { title: 'Rain', youtube_id: '1If-cXUeVws' }
]

released_vol2_videos.each do |video|
  released_vol2_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

puts "✅ Playlist RELEASED vol.2 créée"

puts "🎉 Toutes les nouvelles playlists ont été créées avec succès !"
puts "📊 Résumé :"
puts "   - Pop: 5 playlists (4 standard + 1 premium)"
puts "   - Hits: 2 playlists (0 standard + 2 premium)"
puts "   - Afro: 4 playlists (1 standard + 3 premium)" 
puts "   - Electro: 2 playlists (1 standard + 1 premium)"
puts "   - Reggae: 3 playlists (1 standard + 2 premium)"
puts "   - Rock: 3 playlists (1 standard + 2 premium)"
puts "   - Rap: 13 playlists (4 standard + 9 premium)"
puts "   - Total: 32 playlists (320 vidéos)"

# ===========================================
# BLOG POSTS (SEO)
# ===========================================

puts "📝 Création des articles de blog..."

rap_ivoire_power_ids = %w[
  uQjVJKBrGHo
  fDnY4Bz-ttY
  zdMS4wZxXIs
  -LwHX5Nndcw
  4QLNn0BHjHs
  2vQhkQiPSoA
  s5zPAbaiZx4
  G-sK6B0GKIo
  RQQJfCK-_EY
  1_rhXT_4TMU
]
random_id = rap_ivoire_power_ids.sample
thumbnail_url = "https://img.youtube.com/vi/#{random_id}/maxresdefault.jpg"
playlist = Playlist.find_by(title: "Rap Ivoire Power")
playlist_link = playlist ? "/playlists/#{playlist.id}" : "/playlists"

post_content = <<~HTML
  <p>Chaque mois, Tube'NPlay explore les profondeurs du son pour vous ramener des pépites. Des artistes qui n'ont pas encore percé, mais qui méritent votre swipe. Voici les 10 talents qui font vibrer notre radar ce mois-ci.</p>

  <h2>🔍 Sélection du mois</h2>
  <div class="overflow-x-auto">
    <table class="w-full text-left text-sm">
      <thead>
        <tr>
          <th>🎧 Artiste</th>
          <th>🎵 Titre</th>
          <th>🎙️ Style</th>
          <th>💬 Accroche</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Lesky</td>
          <td>GAWA</td>
          <td>Rap mélodique</td>
          <td>Flow introspectif et prod planante</td>
        </tr>
        <tr>
          <td>Socé</td>
          <td>À Toi</td>
          <td>Rap émotion</td>
          <td>Une lettre ouverte en forme de confession</td>
        </tr>
        <tr>
          <td>Miedjia</td>
          <td>Foua (C'est Facile)</td>
          <td>Afro drill</td>
          <td>Énergie brute et vibe contagieuse</td>
        </tr>
        <tr>
          <td>Leufa</td>
          <td>Il sait</td>
          <td>Trap spirituelle</td>
          <td>Entre prière et punchline</td>
        </tr>
        <tr>
          <td>Le JLO &amp; Ameka Zrai</td>
          <td>Pleure</td>
          <td>Rap fusion</td>
          <td>Deux voix, une douleur partagée</td>
        </tr>
        <tr>
          <td>Lesky</td>
          <td>Béni</td>
          <td>Rap</td>
          <td>Hymne à la résilience</td>
        </tr>
        <tr>
          <td>Kadja</td>
          <td>Tu dis quoi</td>
          <td>Afro pop</td>
          <td>Ambiance festive et refrain entêtant</td>
        </tr>
        <tr>
          <td>Miedjia</td>
          <td>De Même</td>
          <td>Drill</td>
          <td>Flow tranchant et prod sombre</td>
        </tr>
        <tr>
          <td>Albinny</td>
          <td>BlackArtist</td>
          <td>Rap engagé</td>
          <td>Identité forte et message clair</td>
        </tr>
        <tr>
          <td>Kawid</td>
          <td>Si C'est Pas Dieu</td>
          <td>Rap spirituel</td>
          <td>Foi, feu et finesse</td>
        </tr>
      </tbody>
    </table>
  </div>
HTML

post = Post.find_or_initialize_by(slug: "selection-du-mois-rap-ivoire-power", locale: "fr")
post.title = "Sélection du mois : 10 talents Rap Ivoire Power à écouter"
post.excerpt = "Chaque mois, Tube'NPlay repère des artistes émergents. Découvrez notre sélection Rap Ivoire Power et nos 10 coups de cœur."
post.content = post_content
post.category = "Sélection"
post.published = true
post.published_at = Time.current
post.thumbnail_url = thumbnail_url
post.meta_title = "Rap Ivoire Power : 10 artistes à découvrir | Tube'NPlay"
post.meta_description = "Découvrez 10 talents Rap Ivoire Power sélectionnés par Tube'NPlay. Des artistes émergents à écouter dès maintenant."
post.save!

puts "✅ Article de blog créé"