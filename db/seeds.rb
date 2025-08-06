# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Création d'un utilisateur admin
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.password = '123456'
    user.admin = true
  end
  
  # Création d'un utilisateur normal
  user = User.find_or_create_by!(email: 'user@example.com') do |user|
    user.password = '234567'
  end
  
  # Playlist Standard: This is Pop
  pop_playlist = Playlist.find_or_create_by!(title: 'This is Pop') do |playlist|
    playlist.description = 'Les meilleurs hits pop du moment'
    playlist.genre = 'Pop'
    playlist.premium = false
  end
  
  # Vidéos pour la playlist Pop
  pop_videos = [
    { title: 'Dua Lipa - Houdini', youtube_id: 'suAR1PYFNYA' },
    { title: 'Tate McRae - Greedy', youtube_id: 'To4SWGZkEPk' },
    { title: 'Doja Cat - Paint The Town Red', youtube_id: 'm4_9TFeMfJE' },
    { title: 'Olivia Rodrigo - vampire', youtube_id: 'RlPNh_PBZb4' },
    { title: 'Billie Eilish - What Was I Made For?', youtube_id: 'cW8VLC9nnTo' },
    { title: 'Miley Cyrus - Flowers', youtube_id: 'G7KNmW9a75Y' },
    { title: 'SZA - Kill Bill', youtube_id: 'MSRcC626prw' },
    { title: 'Taylor Swift - Anti-Hero', youtube_id: 'b1kbLwvqugk' },
    { title: 'The Weeknd - Die For You', youtube_id: 'uPD0QOGTmMI' },
    { title: 'Ed Sheeran - Eyes Closed', youtube_id: 'u6wOyMUs74I' }
  ]
  
  pop_videos.each do |video|
    pop_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Standard: Pop Play
  pop_playlist_2 = Playlist.find_or_create_by!(title: 'Pop Play') do |playlist|
    playlist.description = 'La playlist parfaite pour danser sur des tubes pop'
    playlist.genre = 'Pop'
    playlist.premium = false
  end
  
  # Vidéos pour la playlist Pop Play
  pop_videos_2 = [
    { title: 'Bruno Mars - Uptown Funk', youtube_id: 'OPf0YbXqDm0' },
    { title: 'Pharrell Williams - Happy', youtube_id: 'ZbZSe6N_BXs' },
    { title: 'Mark Ronson - Nothing Breaks Like a Heart', youtube_id: 'p1zrweVN4l4' },
    { title: 'Rihanna - Diamonds', youtube_id: 'lWA2pjMjpBs' },
    { title: 'Beyoncé - Halo', youtube_id: 'bnVUHWCynig' },
    { title: 'Lady Gaga - Shallow', youtube_id: 'bo_efYhYU2A' },
    { title: 'Adele - Rolling in the Deep', youtube_id: 'rYEDA3JcQqw' },
    { title: 'Justin Timberlake - Can\'t Stop the Feeling', youtube_id: 'ru0K8uYEZWw' },
    { title: 'Ariana Grande - thank u, next', youtube_id: 'gl1aHhXnN1k' },
    { title: 'Sam Smith - Stay With Me', youtube_id: 'pB-5XG-DbAA' }
  ]
  
  pop_videos_2.each do |video|
    pop_playlist_2.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Standard: This is Hip Hop
  hip_hop_playlist_1 = Playlist.find_or_create_by!(title: 'This is Hip Hop') do |playlist|
    playlist.description = 'Le meilleur du hip hop actuel'
    playlist.genre = 'Hip Hop'
    playlist.premium = false
  end
  
  # Vidéos pour la playlist Hip Hop
  hip_hop_videos_1 = [
    { title: 'ENTRE NOUS DEUX · Didi B · Doupi Papillon', youtube_id: 'fkn7f3Nyq88' },
    { title: 'Nothing Without God · POPCAAN', youtube_id: 'wFRyzB170sk' },
    { title: 'HIMRA - NUMBER ONE (FT. MINZ)', youtube_id: 'b16_UBiP4G0' },
    { title: 'Travis Scott - She Going Dumb', youtube_id: 'tN82cGi9kUc' },
    { title: 'Quavo, Lil Baby - Legends', youtube_id: '4cCzuTQ49V8' },
    { title: 'Skillibeng - New Gears', youtube_id: 'Yubuf7k1WZM' },
    { title: 'TOUT VA BIEN · Didi B', youtube_id: 'oQNkebtoIN4' },
    { title: 'Toosii - Party Girl Anthem', youtube_id: 'x4xDmrvHTY0' },
    { title: 'YE - CIRCLES', youtube_id: 'WMexy8iEF7E' },
    { title: 'Didi B - Good vibes', youtube_id: 'wLdtn45riSc' }
  ]
  
  hip_hop_videos_1.each do |video|
    hip_hop_playlist_1.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Standard: Hot New Hip Hop
  hip_hop_playlist_2 = Playlist.find_or_create_by!(title: 'Hot New Hip Hop') do |playlist|
    playlist.description = 'Les dernières sorties hip hop à ne pas manquer'
    playlist.genre = 'Hip Hop'
    playlist.premium = false
  end
  
  # Vidéos pour la playlist Hot New Hip Hop
  hip_hop_videos_2 = [
    { "title": "Didi B - Big Boss", "youtube_id": "_PKbI32lsN8" },
    { "title": "POPCAAN - Firm and Strong", "youtube_id": "0rEBT_Ge3sc" },  
    { "title": "HIMRA - Freestyle Drill Ivoire #5", "youtube_id": "GyIDTBHEOAQ" },
    { "title": "Travis Scott - Stargazing", "youtube_id": "2a8PgqWrc_4" },
    { "title": "Quavo, Lil Baby - Ice Cold", "youtube_id": "4cCzuTQ49V8" },
    { "title": "Skillibeng - Crocodile Teeth", "youtube_id": "m7vsOSIz4ds" },
    { "title": "Didi B - En Haut", "youtube_id": "e0K3OjNHTtA" },
    { "title:": "Toosii - Favorite Song", "youtube_id": "4D89Qr5vH6U" },
    { "title": "YE - Hurricane", "youtube_id": "VRJiK-kdDb4" },
    { "title": "Didi B - Rockstxr", "youtube_id": "YeCRoOnr5vU" }
  ]
  
  hip_hop_videos_2.each do |video|
    hip_hop_playlist_2.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

  # Playlist Standard: Best of Reggae
  reggae_playlist = Playlist.find_or_create_by!(title: 'Best of Reggae') do |playlist|
    playlist.description = 'Les meilleurs morceaux de reggae de tous les temps'
    playlist.genre = 'Reggae'
    playlist.premium = false
  end
  
  # Vidéos pour la playlist Reggae
  reggae_videos = [
    { title: 'Bob Marley - No Woman No Cry', youtube_id: 'IT8XvzIfi4U' },  
    { title: 'UB40 - Red Red Wine', youtube_id: 'zXt56MB-3vc' },
    { title: 'Bob Marley - Three Little Birds', youtube_id: 'HNBCVM4KbUM' },  
    { title: 'Damian Marley - Welcome To Jamrock', youtube_id: '_GZlJGERbvE' },
    { title: 'Bob Marley - Jamming', youtube_id: 'oqVy6eRXc7Q' },
    { title: 'UB40 - Kingston Town', youtube_id: '8Ikz-51w3mo' },
    { title: 'Bob Marley - One Love', youtube_id: 'IN0KkGeEURw' },
    { title: 'Inner Circle - Sweat', youtube_id: 'f7OXGANW9Ic' }, 
    { title: 'Bob Marley - Could You Be Loved', youtube_id: '1ti2YCFgCoI' },
    { title: 'UB40 - Can\'t Help Falling In Love', youtube_id: 'MXVxP8WMc4s' }
  ]
  
  reggae_videos.each do |video|
    reggae_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Standard: This is AfroPop
  afropop_playlist = Playlist.find_or_create_by!(title: 'This is AfroPop') do |playlist|
    playlist.description = 'Les meilleurs sons afropop du moment'
    playlist.genre = 'Afro Pop'
    playlist.premium = false
  end
  
  # Vidéos pour la playlist AfroPop
  afropop_videos = [
    { title: 'Wizkid - Essence ft. Tems', youtube_id: 'm77FDcKg96Q' },
    { title: 'Burna Boy - Last Last', youtube_id: '421w1j87fEM' },
    { title: 'Davido - Fall', youtube_id: '3Iyuym-Gci0' },
    { title: 'Rema - Calm Down', youtube_id: 'CQLsdm1ZYAw' },
    { title: 'Fireboy DML - Peru', youtube_id: 'pekzpzNCNDQ' },
    { title: 'CKay - Emiliana', youtube_id: 'Ypr5QN7Xn_M' },
    { title: 'Ayra Starr - Rush', youtube_id: 'crtQSTYWtqE' },
    { title: 'Tems - Me & U', youtube_id: '1JltlSJH5bY' },
    { title: 'Asake - WHY LOVE', youtube_id: 'MCMyKcUNR8w' },
    { title: 'Joeboy - Sip (Alcohol)', youtube_id: 'UEcAPvoSe_8' }
  ]
  
  afropop_videos.each do |video|
    afropop_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

  # Playlist Premium: Hip Hop Essentials
  hip_hop_essentials = Playlist.find_or_create_by!(title: 'Hip Hop Essentials') do |playlist|
    playlist.description = 'Les classiques indispensables du hip hop'
    playlist.genre = 'Hip Hop'
    playlist.premium = true
  end
  
  # Vidéos pour la playlist Hip Hop Essentials
  hip_hop_essentials_videos = [
    { title: 'Dr. Dre - Still D.R.E. ft. Snoop Dogg', youtube_id: '_CL6n0FJZpk' },
    { title: 'Eminem - Lose Yourself', youtube_id: '_Yhyp-_hX2s' },
    { title: 'The Notorious B.I.G. - Juicy', youtube_id: '_JZom_gVfuw' },
    { title: 'Tupac - California Love', youtube_id: 'J7_bMdYfSws' },
    { title: 'Jay-Z - Empire State of Mind', youtube_id: 'vk6014HuxcE' },
    { title: 'Nas - N.Y. State of Mind', youtube_id: 'hI8A14Qcv68' },
    { title: 'Wu-Tang Clan - C.R.E.A.M.', youtube_id: 'PBwAxmrE194' },
    { title: 'Kendrick Lamar - Alright', youtube_id: 'Z-48u_uWMHY' },
    { title: 'OutKast - Ms. Jackson', youtube_id: 'EUVo8epKwv0' },
    { title: 'Kanye West - Runaway', youtube_id: 'VhEoCOWUtcU' }
  ]
  
  hip_hop_essentials_videos.each do |video|
    hip_hop_essentials.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

  # Playlist Premium: Reggae Vibes
  reggae_vibes = Playlist.find_or_create_by!(title: 'Reggae Vibes') do |playlist|
    playlist.description = 'Les meilleures vibes reggae pour se détendre'
    playlist.genre = 'Reggae'
    playlist.premium = true
  end
  
  # Vidéos pour la playlist Reggae Vibes
  reggae_vibes_videos = [
    { title: 'Steel Pulse - Steppin\' Out', youtube_id: '8SXCPuJCFmA' },
    { title: 'Jimmy Cliff - Many Rivers to Cross', youtube_id: 'doWWHQDWe2k' },
    { title: 'Peter Tosh - Legalize It', youtube_id: 'j6QkVTx2d88' },
    { title: 'Burning Spear - Columbus', youtube_id: 'CZyTqj-vRrM' },
    { title: 'Dennis Brown - Revolution', youtube_id: '0CGI0lS1ir4' },
    { title: 'Gregory Isaacs - Night Nurse', youtube_id: 'K6oYyG0KcvQ' },
    { title: 'Black Uhuru - Guess Who\'s Coming to Dinner', youtube_id: 'KWEGXb2juvM' },
    { title: 'Toots & The Maytals - Pressure Drop', youtube_id: 'DKVB_CtU8XQ' },
    { title: 'Third World - Now That We Found Love', youtube_id: 'XXeY74ttezU' },
    { title: 'Buju Banton - Untold Stories', youtube_id: 'Kb-0Eo0Yk0o' }
  ]
  
  reggae_vibes_videos.each do |video|
    reggae_vibes.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

  # Playlist Premium: Afro Pop Hits
  afro_pop_hits = Playlist.find_or_create_by!(title: 'Afro Pop Hits') do |playlist|
    playlist.description = 'Les meilleurs hits afro pop pour faire la fête'
    playlist.genre = 'Afro Pop'
    playlist.premium = true
  end
  
  # Vidéos pour la playlist Afro Pop Hits
  afro_pop_hits_videos = [
    { title: 'Fally Ipupa - Eloko Oyo', youtube_id: 'T4KNVT2w0mU' },
    { title: 'Tiwa Savage - Koroba', youtube_id: '5goMslKxEWs' },
    { title: 'Diamond Platnumz - Waah! ft. Koffi Olomide', youtube_id: 'HCuTwNgY3_M' },
    { title: 'Sarkodie - Adonai ft. Castro', youtube_id: 'pZvlG-wwWk' },
    { title: 'Yemi Alade - Johnny', youtube_id: 'C_XkTKoDI18' },
    { title: 'P-Square - Personally', youtube_id: 'ttdU19Kwce8' },
    { title: 'D\'Banj - Oliver Twist', youtube_id: 'EUYNnVgkAag' },
    { title: 'Tekno - Pana', youtube_id: '8YhAFBOSk1U' },
    { title: 'Mr Eazi - Skin Tight ft. Efya', youtube_id: 'vk_4yxkgjAI' },
    { title: 'Sauti Sol - Suzanna', youtube_id: 'mFBJtuQ1Llc' }
  ]
  
  afro_pop_hits_videos.each do |video|
    afro_pop_hits.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

  # Playlist Premium: Latin Pop
  latin_pop = Playlist.find_or_create_by!(title: 'Latin Pop') do |playlist|
    playlist.description = 'Le meilleur de la pop latine pour danser'
    playlist.genre = 'Latin'
    playlist.premium = true
  end
  
  # Vidéos pour la playlist Latin Pop
  latin_pop_videos = [
    { title: 'Shakira - Hips Don\'t Lie ft. Wyclef Jean', youtube_id: 'DUT5rEU6pqM' },
    { title: 'Luis Fonsi - Despacito ft. Daddy Yankee', youtube_id: 'kJQP7kiw5Fk' },
    { title: 'Enrique Iglesias - Bailando ft. Descemer Bueno, Gente De Zona', youtube_id: 'NUsoVlDFqZg' },
    { title: 'Ricky Martin - Livin\' La Vida Loca', youtube_id: 'p47fEXGabaY' },
    { title: 'J Balvin, Willy William - Mi Gente', youtube_id: 'wnJ6LuUFpMo' },
    { title: 'Daddy Yankee - Gasolina', youtube_id: 'qGKrc3A6HHM' },
    { title: 'Jennifer Lopez - On The Floor ft. Pitbull', youtube_id: 't4H_Zoh7G5A' },
    { title: 'Ozuna - Dile Que Tu Me Quieres', youtube_id: 'r9Ey0xD9YO0' },
    { title: 'Maluma - Felices los 4', youtube_id: 't_jHrUE5IOk' },
    { title: 'Bad Bunny - Yo Perreo Sola', youtube_id: 'GtSRKwDCaZM' }
  ]
  
  latin_pop_videos.each do |video|
    latin_pop.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end

  # Playlist Premium: Electronic Dance
  electronic_dance = Playlist.find_or_create_by!(title: 'Electronic Dance') do |playlist|
    playlist.description = 'Les meilleurs morceaux électroniques pour danser toute la nuit'
    playlist.genre = 'Electronic'
    playlist.premium = true
  end
  
  # Vidéos pour la playlist Electronic Dance
  electronic_dance_videos = [
    { title: 'Avicii - Levels', youtube_id: '_ovdm2yX4MA' },
    { title: 'David Guetta - Titanium ft. Sia', youtube_id: 'JRfuAukYTKg' },
    { title: 'Calvin Harris - Summer', youtube_id: 'ebXbLfLACGM' },
    { title: 'Swedish House Mafia - Don\'t You Worry Child', youtube_id: '1y6smkh6c-0' },
    { title: 'Martin Garrix - Animals', youtube_id: 'gCYcHz2k5x0' },
    { title: 'Zedd - Clarity ft. Foxes', youtube_id: 'IxxstCcJlsc' },
    { title: 'Skrillex - Bangarang feat. Sirah', youtube_id: 'YJVmu6yttiw' },
    { title: 'Daft Punk - Get Lucky ft. Pharrell Williams, Nile Rodgers', youtube_id: '5NV6Rdv1a3I' },
    { title: 'The Chainsmokers - Don\'t Let Me Down ft. Daya', youtube_id: 'Io0fBr1XBUA' },
    { title: 'Kygo - Firestone ft. Conrad Sewell', youtube_id: '9Sc-ir2UwGU' }
  ]
  
  electronic_dance_videos.each do |video|
    electronic_dance.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Création de quelques scores pour tester
  Score.find_or_create_by!(user: user, playlist: pop_playlist) do |score|
    score.points = 7
  end
  
  Score.find_or_create_by!(user: user, playlist: hip_hop_playlist_1) do |score|
    score.points = 5
  end
  
  Score.find_or_create_by!(user: user, playlist: reggae_playlist) do |score|
    score.points = 8
  end
  
  Score.find_or_create_by!(user: admin, playlist: pop_playlist) do |score|
    score.points = 9
  end
  
  Score.find_or_create_by!(user: admin, playlist: hip_hop_playlist_1) do |score|
    score.points = 6
  end
  
  Score.find_or_create_by!(user: admin, playlist: reggae_playlist) do |score|
    score.points = 7
  end
  
  # Badges Seeds
  # Competitor Badges
  [
    {
      name: 'Bronze Competitor',
      badge_type: 'competitor',
      level: 'bronze',
      points_required: 1000,
      description: 'A solid start in the competition!',
      reward_type: 'standard',
      reward_description: 'Access to exclusive playlists'
    },
    {
      name: 'Silver Competitor',
      badge_type: 'competitor',
      level: 'silver',
      points_required: 3000,
      description: 'You\'re becoming a force to be reckoned with!',
      reward_type: 'standard',
      reward_description: 'Photos dédicacées'
    },
    {
      name: 'Gold Competitor',
      badge_type: 'competitor',
      level: 'gold',
      points_required: 5000,
      description: 'A true champion of the competition!',
      reward_type: 'premium',
      reward_description: 'Invitation à un concert VIP'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Engager Badges
  [
    {
      name: 'Bronze Engager',
      badge_type: 'engager',
      level: 'bronze',
      points_required: 500,
      description: 'You\'re starting to make your mark!',
      reward_type: 'standard',
      reward_description: 'Accès anticipé à des playlists'
    },
    {
      name: 'Silver Engager',
      badge_type: 'engager',
      level: 'silver',
      points_required: 1500,
      description: 'Your engagement is making waves!',
      reward_type: 'standard',
      reward_description: 'Photos dédicacées'
    },
    {
      name: 'Gold Engager',
      badge_type: 'engager',
      level: 'gold',
      points_required: 3000,
      description: 'You\'re the heart of the community!',
      reward_type: 'premium',
      reward_description: 'Rencontre avec un artiste'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Critic Badges
  [
    {
      name: 'Bronze Critic',
      badge_type: 'critic',
      level: 'bronze',
      points_required: 500,
      description: 'Your opinions are valued!',
      reward_type: 'standard',
      reward_description: 'Accès à du contenu exclusif'
    },
    {
      name: 'Silver Critic',
      badge_type: 'critic',
      level: 'silver',
      points_required: 2000,
      description: 'Your taste is impeccable!',
      reward_type: 'standard',
      reward_description: 'Photos dédicacées'
    },
    {
      name: 'Gold Critic',
      badge_type: 'critic',
      level: 'gold',
      points_required: 4000,
      description: 'You\'re a true connoisseur!',
      reward_type: 'premium',
      reward_description: 'Participation à des interviews live'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Challenger Badges
  [
    {
      name: 'Bronze Challenger',
      badge_type: 'challenger',
      level: 'bronze',
      points_required: 800,
      description: 'You\'re climbing the ranks!',
      reward_type: 'standard',
      reward_description: 'Accès anticipé à du contenu exclusif'
    },
    {
      name: 'Silver Challenger',
      badge_type: 'challenger',
      level: 'silver',
      points_required: 1500,
      description: 'You\'re a formidable opponent!',
      reward_type: 'standard',
      reward_description: 'Merchandising exclusif'
    },
    {
      name: 'Gold Challenger',
      badge_type: 'challenger',
      level: 'gold',
      points_required: 2500,
      description: 'You\'re the ultimate champion!',
      reward_type: 'premium',
      reward_description: 'Invitation à un concert VIP'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Users Seeds
  # Création des utilisateurs de test
  driss = User.find_or_create_by!(email: 'driss@example.com') do |user|
    user.password = '123456'
    user.username = 'Driss'
  end
  
  theo = User.find_or_create_by!(email: 'theo@example.com') do |user|
    user.password = '123456'
    user.username = 'Théo'
  end
  
  vb = User.find_or_create_by!(email: 'vb@example.com') do |user|
    user.password = '123456'
    user.username = 'VB'
  end
  
  # Scores pour Driss (Competitor)
  pop_playlist.scores.find_or_create_by!(user: driss) do |score|
    score.points = 950
  end
  
  hip_hop_playlist_1.scores.find_or_create_by!(user: driss) do |score|
    score.points = 850
  end
  
  reggae_playlist.scores.find_or_create_by!(user: driss) do |score|
    score.points = 900
  end
  
  # Swipes pour Driss
  # Créons d'abord un jeu pour Driss
  driss_game = Game.find_or_create_by!(user: driss, playlist: pop_playlist)

  pop_playlist.videos.each do |video|
    Swipe.find_or_create_by!(user: driss, video: video, game: driss_game) do |swipe|
      swipe.action = 'like'
      swipe.liked = true
      swipe.playlist = pop_playlist
    end
  end
  
  # Scores pour Théo (Engager)
  pop_playlist.scores.find_or_create_by!(user: theo) do |score|
    score.points = 400
  end
  
  hip_hop_playlist_1.scores.find_or_create_by!(user: theo) do |score|
    score.points = 350
  end
  
  reggae_playlist.scores.find_or_create_by!(user: theo) do |score|
    score.points = 380
  end
  
  # Swipes pour Théo
  # Créons d'abord un jeu pour Théo
  theo_game = Game.find_or_create_by!(user: theo, playlist: pop_playlist)

  pop_playlist.videos.each do |video|
    action = ['like', 'dislike'].sample
    Swipe.find_or_create_by!(user: theo, video: video, game: theo_game) do |swipe|
      swipe.action = action
      swipe.liked = (action == 'like')
      swipe.playlist = pop_playlist
    end
  end
  
  # Scores pour VB (Challenger)
  pop_playlist.scores.find_or_create_by!(user: vb) do |score|
    score.points = 2000
  end
  
  hip_hop_playlist_1.scores.find_or_create_by!(user: vb) do |score|
    score.points = 1800
  end
  
  reggae_playlist.scores.find_or_create_by!(user: vb) do |score|
    score.points = 1900
  end
  
  # Swipes pour VB
  # Créons d'abord un jeu pour VB
  vb_game = Game.find_or_create_by!(user: vb, playlist: pop_playlist)

  pop_playlist.videos.each do |video|
    Swipe.find_or_create_by!(user: vb, video: video, game: vb_game) do |swipe|
      swipe.action = 'like'
      swipe.liked = true
      swipe.playlist = pop_playlist
    end
  end
  
  # Création des badges
  # Badges pour The Competitor
  Badge.find_or_create_by!(badge_type: "competitor", level: "bronze") do |badge|
    badge.name = "Bronze Competitor"
    badge.points_required = 100
    badge.description = "Vous commencez à vous faire remarquer dans les compétitions"
    badge.reward_type = "standard"
    badge.reward_description = "Accès à une playlist exclusive"
  end
  
  Badge.find_or_create_by!(badge_type: "competitor", level: "silver") do |badge|
    badge.name = "Silver Competitor"
    badge.points_required = 500
    badge.description = "Vous êtes un compétiteur redoutable"
    badge.reward_type = "premium"
    badge.reward_description = "Accès à des playlists premium"
  end
  
  Badge.find_or_create_by!(badge_type: "competitor", level: "gold") do |badge|
    badge.name = "Gold Competitor"
    badge.points_required = 1000
    badge.description = "Vous êtes un champion incontesté"
    badge.reward_type = "premium"
    badge.reward_description = "Accès VIP à toutes les playlists"
  end
  
  # Badges pour The Engager
  Badge.find_or_create_by!(badge_type: "engager", level: "bronze") do |badge|
    badge.name = "Bronze Engager"
    badge.points_required = 300
    badge.description = "Vous commencez à vous engager activement"
    badge.reward_type = "standard"
    badge.reward_description = "Accès à des statistiques détaillées"
  end
  
  Badge.find_or_create_by!(badge_type: "engager", level: "silver") do |badge|
    badge.name = "Silver Engager"
    badge.points_required = 600
    badge.description = "Vous êtes un membre très actif"
    badge.reward_type = "premium"
    badge.reward_description = "Accès à des fonctionnalités avancées"
  end
  
  Badge.find_or_create_by!(badge_type: "engager", level: "gold") do |badge|
    badge.name = "Gold Engager"
    badge.points_required = 1200
    badge.description = "Vous êtes un pilier de la communauté"
    badge.reward_type = "premium"
    badge.reward_description = "Accès à des fonctionnalités exclusives"
  end
  
  # Création des utilisateurs de test si nécessaire
  unless User.exists?(email: "theo@example.com")
    theo = User.create!(
      email: "theo@example.com",
      password: "123456",
      password_confirmation: "123456"
    )
    
    # Attribuer quelques badges à Théo
    bronze_competitor = Badge.find_by(name: "Bronze Competitor")
    if bronze_competitor
      UserBadge.create!(
        user: theo,
        badge: bronze_competitor,
        earned_at: 2.days.ago,
        points_at_earned: 120
      )
    end
    
    bronze_engager = Badge.find_by(name: "Bronze Engager")
    if bronze_engager
      UserBadge.create!(
        user: theo,
        badge: bronze_engager,
        earned_at: 5.days.ago,
        points_at_earned: 55
      )
    end
  end

# Update badge images
{
  'competitor' => {
    'bronze' => 'dropmixpop.webp',
    'silver' => 'NFT.jpg',
    'gold' => 'VIP-gold.jpg'
  },
  'engager' => {
    'bronze' => 'pandora-playlist-collage.webp',
    'silver' => 'photos-dedicacees.jpeg',
    'gold' => 'concert-virtuel.jpg'
  },
  'critic' => {
    'bronze' => 'Best-Music.webp',
    'silver' => 'artist_message.jpeg',
    'gold' => 'backstage_virtuel.jpg'
  },
  'challenger' => {
    'bronze' => 'Exclusive_content.jpeg',
    'silver' => 'music_merch.jpeg',
    'gold' => 'interview.jpg'
  }
}.each do |badge_type, levels|
  levels.each do |level, image|
    badge = Badge.find_by(badge_type: badge_type, level: level)
    badge.update(image: image) if badge
  end
end

# Playlist Exclusive: Exclusive Playlist
exclusive_playlist = Playlist.find_or_create_by!(title: 'Exclusive Playlist') do |playlist|
  playlist.description = 'Une playlist réservée aux membres ayant débloqué la récompense exclusive.'
  playlist.genre = 'Exclusive'
  playlist.premium = true
  playlist.exclusive = true
end

exclusive_videos = [
  { title: 'Help Me Find My Drawls · Tonio Armani', youtube_id: 'Qzq45Z95Ass' },
  { title: 'Joy · Snoop Dogg', youtube_id: 'bQrs57Uc7eY' },
  { title: 'HIMRA - ÇA GLOW', youtube_id: '9_esOJNo7tA' },
  { title: 'My Mind Playin Tricks on Me · Geto Boys', youtube_id: '7vHA5lqrMMI' },
  { title: 'Funk Pop Type Beat, Funky Type Beat ("feels") dannyebtracks', youtube_id: 'lwvoRUDz7Ww' },
  { title: 'Rapid Fire · Cruel Santino', youtube_id: '40mssPDJodE' },
  { title: 'White Noise · Joyner Lucas', youtube_id: 'cMPzYnVD0ng' },
  { title: 'Fuego · Manu Crooks · Anfa Rose', youtube_id: 'u7i9oCgsukE' },
  { title: 'Mary Jane (All Night Long) · Mary J. Blige', youtube_id: 'XWP9LWeE0-I' },
  { title: 'Cowgirl Trailride (feat. Tonio Armani) S Dott', youtube_id: '33TIBfNR_bM' }
]

exclusive_videos.each do |video|
  exclusive_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Créer les liaisons entre badges et playlists exclusives
# Le badge "Bronze Competitor" débloque la "Exclusive Playlist" (Accès à une playlist exclusive)
bronze_competitor_badge = Badge.find_by(badge_type: 'competitor', level: 'bronze')
if bronze_competitor_badge && exclusive_playlist
  BadgePlaylistUnlock.find_or_create_by!(badge: bronze_competitor_badge, playlist: exclusive_playlist)
end

# Note: Les badges sont maintenant attribués naturellement via BadgeService
# Pas de badges forcés pour maintenir la cohérence du gameplay

# Challenge Reward Playlist 1
challenge_reward_playlist_1 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist 1') do |playlist|
  playlist.description = 'Playlist exclusive débloquée via les récompenses challenge.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
end

challenge_reward_videos_1 = [
  { title: 'Help Me Find My Drawls · Tonio Armani', youtube_id: 'Qzq45Z95Ass' },
  { title: 'Joy · Snoop Dogg', youtube_id: 'bQrs57Uc7eY' },
  { title: 'My Mind Playin Tricks on Me · Geto Boys', youtube_id: '7vHA5lqrMMI' },
  { title: 'Funk Pop Type Beat, Funky Type Beat ("feels") dannyebtracks', youtube_id: 'lwvoRUDz7Ww' },
  { title: 'Rapid Fire · Cruel Santino', youtube_id: '40mssPDJodE' },
  { title: 'White Noise · Joyner Lucas', youtube_id: 'cMPzYnVD0ng' },
  { title: 'Fuego · Manu Crooks · Anfa Rose', youtube_id: 'u7i9oCgsukE' },
  { title: 'Mary Jane (All Night Long) · Mary J. Blige', youtube_id: 'XWP9LWeE0-I' },
  { title: 'Cowgirl Trailride (feat. Tonio Armani) S Dott', youtube_id: '33TIBfNR_bM' },
  { title: 'Go Anywhere · Sally Green', youtube_id: '2OMK7sQd-Qk' }
]

challenge_reward_videos_1.each do |video|
  challenge_reward_playlist_1.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Challenge Reward Playlist 2
challenge_reward_playlist_2 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist 2') do |playlist|
  playlist.description = 'Deuxième playlist exclusive débloquée via les récompenses challenge.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
end

challenge_reward_videos_2 = [
  { title: 'HIMRA - ÇA GLOW', youtube_id: '9_esOJNo7tA' },
  { title: 'Didi B - Big Boss', youtube_id: '_PKbI32lsN8' },
  { title: 'POPCAAN - Firm and Strong', youtube_id: '0rEBT_Ge3sc' },
  { title: 'HIMRA - Freestyle Drill Ivoire #5', youtube_id: 'GyIDTBHEOAQ' },
  { title: 'Travis Scott - Stargazing', youtube_id: '2a8PgqWrc_4' },
  { title: 'Quavo, Lil Baby - Ice Cold', youtube_id: '4cCzuTQ49V8' },
  { title: 'Skillibeng - Crocodile Teeth', youtube_id: 'm7vsOSIz4ds' },
  { title: 'Didi B - En Haut', youtube_id: 'e0K3OjNHTtA' },
  { title: 'Toosii - Favorite Song', youtube_id: '4D89Qr5vH6U' },
  { title: 'YE - Hurricane', youtube_id: 'VRJiK-kdDb4' }
]

challenge_reward_videos_2.each do |video|
  challenge_reward_playlist_2.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Créer les liaisons entre badges et playlists de récompenses challenge
# Le badge "Bronze Challenger" débloque la "Challenge Reward Playlist 1"
bronze_challenger_badge = Badge.find_by(badge_type: 'challenger', level: 'bronze')
if bronze_challenger_badge && challenge_reward_playlist_1
  BadgePlaylistUnlock.find_or_create_by!(badge: bronze_challenger_badge, playlist: challenge_reward_playlist_1)
end

# Le badge "Silver Challenger" débloque la "Challenge Reward Playlist 2"
silver_challenger_badge = Badge.find_by(badge_type: 'challenger', level: 'silver')
if silver_challenger_badge && challenge_reward_playlist_2
  BadgePlaylistUnlock.find_or_create_by!(badge: silver_challenger_badge, playlist: challenge_reward_playlist_2)
end

# Note: Les Challenge Reward Playlists sont maintenant gérées par le système de récompenses aléatoires
# Elles seront débloquées de manière aléatoire quand un utilisateur atteint 3 badges (niveau Challenge)
# et ne seront jamais la même 2 fois de suite grâce au système anti-répétition
