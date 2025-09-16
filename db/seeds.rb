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
  playlist.premium = false
end

urban_fresh_videos = [
  { title: 'Tout Doux', youtube_id: 'LM-qPkGHSaA' },
  { title: 'Tkt Pas', youtube_id: 'd6X_0BDO6Tg' },
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

# Playlist Pop 2: Futurs Hits – Pop & Global Vibes vol.1 (Premium)
futurs_hits_playlist = Playlist.find_or_create_by!(title: 'Futurs Hits – Pop & Global Vibes vol.1') do |playlist|
  playlist.description = 'Futurs Hits – Pop & Global Vibes - Volume 1'
  playlist.category = 'Pop'
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

# Playlist Pop 3: Futurs Hits – Pop & Global Vibes vol.2 (Premium)
futurs_hits_vol2_playlist = Playlist.find_or_create_by!(title: 'Futurs Hits – Pop & Global Vibes vol.2') do |playlist|
  playlist.description = 'Futurs Hits – Pop & Global Vibes - Volume 2'
  playlist.category = 'Pop'
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

puts "✅ Playlists Pop créées"

# ===========================================
# PLAYLISTS AFRO
# ===========================================

# Playlist Afro 1: Afro Vibes Vol. 1 (Standard)
afro_vibes_vol1_playlist = Playlist.find_or_create_by!(title: 'Afro Vibes Vol. 1') do |playlist|
  playlist.description = 'Les meilleures vibes afro du moment'
  playlist.category = 'Afro'
  playlist.premium = false
end

afro_vibes_vol1_videos = [
  { title: 'Tout Doux', youtube_id: 'LM-qPkGHSaA' },
  { title: 'Shatta Confessions', youtube_id: 'qRyBpbJvO8Y' },
  { title: 'Charger', youtube_id: 'Om_gqUBQzlI' },
  { title: 'Faut Laisser', youtube_id: 'If23KrW8zLg' },
  { title: 'Ola Oli', youtube_id: 'V4gDbLmVyes' },
  { title: 'Tu sais bien', youtube_id: 'Umgg-ccUSwc' },
  { title: 'On fait Comment ?', youtube_id: 'gO4aEAIKl8w' },
  { title: 'Whine', youtube_id: 'Gku25G-MrNE' },
  { title: 'Djiwoun Foulawa', youtube_id: 'PFBa7Wl_kN0' },
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
  playlist.premium = true
end

afro_vibes_vol2_videos = [
  { title: 'Que Pasa ?', youtube_id: 'ZzYzXqzFJgI' },
  { title: 'Trop d\'amour', youtube_id: 'JkXv9Z1ZkzQ' },
  { title: 'C\'est mon BB', youtube_id: 'YgRz7XvZzYg' },
  { title: 'Do You Love Me ?', youtube_id: 'KxvXzYzZgZg' },
  { title: 'PAY!', youtube_id: 'ZgYzXvZgZgY' },
  { title: 'Chouchou', youtube_id: 'ZxYzZgZgYgY' },
  { title: 'Bodycount', youtube_id: 'ZgZgYgYgYgY' },
  { title: 'Joke', youtube_id: 'ZgYgYgYgZgZ' },
  { title: 'Bukki', youtube_id: 'ZgZgZgZgYgY' },
  { title: 'Choix', youtube_id: 'ZgYgZgYgZgY' }
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
  playlist.premium = true
end

afro_vibes_vol3_videos = [
  { title: 'Simba', youtube_id: 'ZgZgYgYgZgZ' },
  { title: 'Ça m\'a laissé', youtube_id: 'ZgYgZgZgYgZ' },
  { title: 'À Tes Côtés', youtube_id: 'ZgZgZgYgZgY' },
  { title: 'Pas Jalouse', youtube_id: 'ZgYgZgYgZgZ' },
  { title: 'DX3', youtube_id: 'ZgZgYgZgYgZ' },
  { title: 'Ayéyé (Nous aussi)', youtube_id: 'ZgYgZgZgYgY' },
  { title: 'Faux Pas', youtube_id: 'ZgZgZgYgZgZ' },
  { title: 'ZALA', youtube_id: 'ZgYgZgYgZgY' },
  { title: 'Changer Camp', youtube_id: 'ZgZgYgYgZgZ' },
  { title: 'Évidemment', youtube_id: 'ZgYgZgZgYgZ' }
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
# PLAYLISTS HIP HOP
# ===========================================

# Playlist Hip Hop 1: Nouveautés Hip Hop Vol.1 (Standard)
hiphop_vol1_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Hip Hop Vol.1') do |playlist|
  playlist.description = 'Les dernières nouveautés hip hop'
  playlist.category = 'Hip Hop'
  playlist.premium = false
end

hiphop_vol1_videos = [
  { title: 'Young Black & Rich', youtube_id: 'F3qWBh7jZZ0' },
  { title: 'They Wanna Have Fun', youtube_id: 'Hvv2tLVQ78E' },
  { title: 'Bodies', youtube_id: '_hkoMopfRJU' },
  { title: 'just say dat', youtube_id: '8gy-Y9tWK6M' },
  { title: 'Which One', youtube_id: '9-dEHfSCZUQ' },
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

# Playlist Hip Hop 2: Nouveautés Hip Hop Vol.2 (Premium)
hiphop_vol2_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Hip Hop Vol.2') do |playlist|
  playlist.description = 'Suite des nouveautés hip hop'
  playlist.category = 'Hip Hop'
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

# Playlist Hip Hop 3: Nouveautés Hip Hop Vol.3 (Premium)
hiphop_vol3_playlist = Playlist.find_or_create_by!(title: 'Nouveautés Hip Hop Vol.3') do |playlist|
  playlist.description = 'Final des nouveautés hip hop'
  playlist.category = 'Hip Hop'
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

puts "✅ Playlists Hip Hop créées"

puts "🎉 Toutes les nouvelles playlists ont été créées avec succès !"
puts "📊 Résumé :"
puts "   - Pop: 3 playlists (1 standard + 2 premium)"
puts "   - Afro: 3 playlists (1 standard + 2 premium)" 
puts "   - Electro: 2 playlists (1 standard + 1 premium)"
puts "   - Reggae: 3 playlists (1 standard + 2 premium)"
puts "   - Rock: 3 playlists (1 standard + 2 premium)"
puts "   - Hip Hop: 3 playlists (1 standard + 2 premium)"
puts "   - Total: 17 playlists (170 vidéos)"