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
  
  # Playlist Standard: Afro Rap
  afro_rap_playlist = Playlist.find_or_create_by!(title: 'Afro Rap') do |playlist|
    playlist.description = 'Un mix équilibré de rap ivoirien moderne avec des sonorités futuristes'
    playlist.genre = 'Afro Rap'
    playlist.premium = false
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist Afro Rap
  afro_rap_videos = [
    { title: 'HIMRA - NUMBER ONE (FT. MINZ)', youtube_id: 'b16_UBiP4G0' },
    { title: 'Didi B - GO feat @jrk1912', youtube_id: 'I-_YDWMXTv0' },
    { title: 'ZOH CATALEYA - TOURA DRILL 1', youtube_id: 'IDakTWRbG_g' },
    { title: 'Didi B - DX3 feat MHD', youtube_id: '3madRVVh00I' },
    { title: 'Bignyne Wiz - Haut Niveau', youtube_id: 'NEW_ID_1' },
    { title: 'Didi B - Fatúmata feat Naira Marley', youtube_id: '2HxJ1R8_xV4' },
    { title: 'HIMRA - ROI IVOIRIEN (2025)', youtube_id: 'gAhiONhqhpo' },
    { title: 'Didi B - Rockstxr', youtube_id: 'YeCRoOnr5vU' },
    { title: 'SINDIKA x DIDI B - RODELA', youtube_id: 'c25xChh56OQ' },
    { title: 'Didi B - 2025 (Official Music Video)', youtube_id: 'yzWENpeiZzc' }
  ]
  
  afro_rap_videos.each do |video|
    afro_rap_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Standard: Afro Trap
  afro_trap_playlist = Playlist.find_or_create_by!(title: 'Afro Trap') do |playlist|
    playlist.description = 'Les meilleurs sons trap et street du rap ivoirien'
    playlist.genre = 'Afro Trap'
    playlist.premium = false
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist Afro Trap
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
  
  # Playlist Standard: Rap Ivoire Power
  rap_ivoire_power_playlist = Playlist.find_or_create_by!(title: 'Rap Ivoire Power') do |playlist|
    playlist.description = 'Des sons apaisants et mélodiques pour se détendre'
    playlist.genre = 'Rap Ivoire'
    playlist.premium = false
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist Rap Ivoire Power
  rap_ivoire_power_videos = [
    { title: 'À Toi – Socé', youtube_id: 'fDnY4Bz-ttY' },
    { title: 'GAWA – Lesky', youtube_id: 'uQjVJKBrGHo' },
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

  # Playlist Premium: Afro Vibes
  afro_vibes = Playlist.find_or_create_by!(title: 'Afro Vibes') do |playlist|
    playlist.description = 'Un mélange éclectique d\'ambiances et de styles variés'
    playlist.genre = 'Afro Vibes'
    playlist.premium = true
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist Afro Vibes
  afro_vibes_videos = [
    { title: 'JOSEY - Le Monde Est à Nous (Official Music Video)', youtube_id: 'AzKUqSNSU5Y' },
    { title: 'Dans Dos – Akim Papichulo', youtube_id: '_pYzyRrXM0o' },
    { title: 'MARASSE – J-Haine', youtube_id: 'RhyiJQ8H7Fg' },
    { title: 'Kedjevara - ça fait mal (Clip Officiel)', youtube_id: 'gcpq4wDm9gM' },
    { title: 'MOUMENT – Boykito', youtube_id: 'YzTHnIVDOHI' },
    { title: 'BEURRE – TC', youtube_id: 'yGCK_59VVM0' },
    { title: 'MATA CRAZY KPALO – Sokeï', youtube_id: 'WaABvOJnq_Y' },
    { title: 'UNDER THE SUN – Jeune Lion', youtube_id: '_2SDQ2DZv08' },
    { title: 'BODOINGADAI – 3xdavs ft. Didi B', youtube_id: 'uhoIdYPVcfc' },
    { title: '15500 VOLTS – Lil Jay Bingerack', youtube_id: 'B39sdzpWnTI' }
  ]
  
  afro_vibes_videos.each do |video|
    afro_vibes.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Premium: This is Rap Ivoire
  this_is_rap_ivoire = Playlist.find_or_create_by!(title: 'This is Rap Ivoire') do |playlist|
    playlist.description = 'Le pur rap ivoirien dans toute sa splendeur'
    playlist.genre = 'Rap Ivoire'
    playlist.premium = true
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist This is Rap Ivoire
  this_is_rap_ivoire_videos = [
    { title: 'Lograndvic – Trap Djou 2', youtube_id: 'V3HR6P4xb8k' },
    { title: 'Tripa Gninnin – Dans l\'eau', youtube_id: 'M0KVSRHjWN4' },
    { title: 'Kadja – Freestyle KORDIAL', youtube_id: 'hE8uFdBHwtA' },
    { title: 'Black K & Fior 2 Bior – Tu veux gâter', youtube_id: 'dREDKBQ_nuM' },
    { title: 'PHILIPAYNE – Undertaker', youtube_id: 'LQalf-Ten24' },
    { title: 'HIMRA – Nouveau Boss', youtube_id: '_qMfCB2sJls' },
    { title: 'SINDIKA – Boyaux', youtube_id: 'NEW_ID_2' },
    { title: 'Didi B – PADRÉ VELI / VODOO FREESTYLE', youtube_id: '8yQv8iXGg5o' },
    { title: 'DEFTY – Taper Créer', youtube_id: 'SbuH4o3eDSM' },
    { title: 'Tripa Gninnin feat Latop – Pourquoi tu gnan', youtube_id: 'X0OeoOqwT3M' }
  ]
  
  this_is_rap_ivoire_videos.each do |video|
    this_is_rap_ivoire.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Premium: Drill Rap Afro
  drill_rap_afro = Playlist.find_or_create_by!(title: 'Drill Rap Afro') do |playlist|
    playlist.description = 'Les meilleurs freestyles et sons drill de la scène ivoirienne'
    playlist.genre = 'Drill Rap'
    playlist.premium = true
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist Drill Rap Afro
  drill_rap_afro_videos = [
    { title: 'BMUXX CARTER ft. Didi B – 24H CHRONO', youtube_id: 'LQhTtxfmxAU' },
    { title: 'HIMRA x PHILIPAYNE – Freestyle Drill Ivoire #4', youtube_id: 'OvIWDW10GhI' },
    { title: 'PHILIPAYNE – Contrat x Himra', youtube_id: 'ypXaXwE0Yq4' },
    { title: 'Elow\'n – Piégé', youtube_id: 'gcrisZnEztU' },
    { title: 'Black K – NO NO NO', youtube_id: 'IMxKsecyHPk' },
    { title: 'Lil Jay Bingerack – 15500 VOLTS', youtube_id: 'ZTWJ_jfSIug' },
    { title: 'D14 – DAGBACHI ft. Shado Chris & JM', youtube_id: 'kmABxEW_vq0' },
    { title: 'Didi B – Forcement', youtube_id: 'PXnjCEpP9rE' },
    { title: 'J-Haine – CAMELEON', youtube_id: 'geHi7DmvE7g' },
    { title: '3XDAVS ft. Didi B – BODOINGADAI', youtube_id: 'uhoIdYPVcfc' }
  ]
  
  drill_rap_afro_videos.each do |video|
    drill_rap_afro.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Premium: Flow Rap Afro
  flow_rap_afro = Playlist.find_or_create_by!(title: 'Flow Rap Afro') do |playlist|
    playlist.description = 'Des flows exceptionnels dans des ambiances uniques'
    playlist.genre = 'Flow Rap'
    playlist.premium = true
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist Flow Rap Afro
  flow_rap_afro_videos = [
    { title: 'HIMRA – G3N3RATION N3RF ft. Kerchak', youtube_id: 'o3eRvNoPK80' },
    { title: 'Widgunz – Ma girlfriend ft. Chrystel', youtube_id: '2GYAsAl8XG0' },
    { title: 'Tripa Gninnin – Kirikou', youtube_id: 'UOfrbereOFE' },
    { title: 'Kadja – Les Meilleurs', youtube_id: 'FsfwYxEmxQw' },
    { title: 'PACO ft. Fireman – CUP', youtube_id: '4wMmF5obkDA' },
    { title: 'Tripa Gninnin – C 1 JEU', youtube_id: 'DjM1GVoa5E8' },
    { title: 'Suspect 95 – LE PARTI 2', youtube_id: 'SgPVwm9HCko' },
    { title: 'J-Haine – MARASSE', youtube_id: 'NEW_ID_3' },
    { title: 'HIMRA – Freestyle Drill Ivoire #5', youtube_id: 'GyIDTBHEOAQ' },
    { title: 'Suspect 95 – HOLYGHOST', youtube_id: '8fOuA6V31YU' }
  ]
  
  flow_rap_afro_videos.each do |video|
    flow_rap_afro.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Premium: Urban Rap Afro
  urban_rap_afro = Playlist.find_or_create_by!(title: 'Urban Rap Afro') do |playlist|
    playlist.description = 'Les meilleures punchlines et sons street du rap ivoirien'
    playlist.genre = 'Urban Rap'
    playlist.premium = true
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Rap'
  end
  
  # Vidéos pour la playlist Urban Rap Afro
  urban_rap_afro_videos = [
    { title: 'PHILIPAYNE – Ils Disent Quoi', youtube_id: 'mPT2Kf6c6Eg' },
    { title: 'Black K – TITI FLY3#', youtube_id: 'sEtuJ5ZX6_g' },
    { title: 'Elow\'n – BPC Freestyle', youtube_id: 'cO3WEw7RQUg' },
    { title: 'NAS ft. Didi B, Sindika, Dopelym… – BENI', youtube_id: 'oWIskZqDf_U' },
    { title: 'Elow\'n – Bolide Nerveux', youtube_id: 'l9Uc-Oteino' },
    { title: 'HIMRA – BÂTON NON NON', youtube_id: '3Eiq6mv8Vlo' },
    { title: 'Kadja – Tu dis quoi', youtube_id: 'NEW_ID_4' },
    { title: 'Black K – LAAARGE FLY1#', youtube_id: 'ZHiejZVpvgQ' },
    { title: 'Didi B – Rockstxr', youtube_id: 'NEW_ID_5' },
    { title: 'Suspect 95 – META VOL.2', youtube_id: 'Z7sbpd4fLyE' }
  ]
  
  urban_rap_afro_videos.each do |video|
    urban_rap_afro.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Premium: Afro Flow
  afro_flow = Playlist.find_or_create_by!(title: 'Afro Flow') do |playlist|
    playlist.description = 'Les flows les plus techniques et punchlines les plus percutantes'
    playlist.genre = 'Afro Flow'
    playlist.premium = true
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Flow'
  end
  
  # Vidéos pour la playlist Afro Flow
  afro_flow_videos = [
    { title: 'Lograndvic – Trap Djou 2', youtube_id: 'NEW_ID_6' },
    { title: 'Tripa Gninnin – Dans l\'eau (Freestyle Gninnin 2)', youtube_id: '8y-iUrYrHT4' },
    { title: 'Kadja – Freestyle KORDIAL 2', youtube_id: 'bZkMs9bHpi4' },
    { title: 'Black K & Fior 2 Bior – Tu veux gâter', youtube_id: 'WdcJn_O-tVM' },
    { title: 'PHILIPAYNE – Undertaker', youtube_id: 'NEW_ID_7' },
    { title: 'HIMRA – Nouveau Boss', youtube_id: '_qMfCB2sJls' },
    { title: 'SINDIKA – Boyaux', youtube_id: 'NEW_ID_8' },
    { title: 'DEFTY – Taper Créer', youtube_id: 'NEW_ID_9' },
    { title: 'Tripa Gninnin feat Latop – Pourquoi tu gnan', youtube_id: 'NEW_ID_10' },
    { title: 'Elow\'n - Bolide Nerveux', youtube_id: 'l9Uc-Oteino' }
  ]
  
  afro_flow_videos.each do |video|
    afro_flow.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist Premium: Afro Melow
  afro_melow = Playlist.find_or_create_by!(title: 'Afro Melow') do |playlist|
    playlist.description = 'Un mélange unique de drill, street et mélodie'
    playlist.genre = 'Afro Melow'
    playlist.premium = true
    playlist.category = 'Rap'
    playlist.subcategory = 'Afro Melow'
  end
  
  # Vidéos pour la playlist Afro Melow
  afro_melow_videos = [
    { title: 'Black K – TITI FLY3#', youtube_id: 'sEtuJ5ZX6_g' },
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
    afro_melow.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
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
  
  Score.find_or_create_by!(user: user, playlist: afro_rap_playlist) do |score|
    score.points = 5
  end
  
  Score.find_or_create_by!(user: user, playlist: reggae_playlist) do |score|
    score.points = 8
  end
  
  Score.find_or_create_by!(user: admin, playlist: pop_playlist) do |score|
    score.points = 9
  end
  
  Score.find_or_create_by!(user: admin, playlist: afro_rap_playlist) do |score|
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
  
  afro_rap_playlist.scores.find_or_create_by!(user: driss) do |score|
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
  
  afro_rap_playlist.scores.find_or_create_by!(user: theo) do |score|
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
  
  afro_rap_playlist.scores.find_or_create_by!(user: vb) do |score|
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
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
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

# Challenge Reward Playlist 2 - Artistes similaires à ceux de la Playlist 1
challenge_reward_playlist_2 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist 2') do |playlist|
  playlist.description = 'Deuxième playlist exclusive débloquée via les récompenses challenge - Artistes similaires.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_2 = [
  # Similaire à Tonio Armani (Hip Hop/Rap) - Artiste différent
  { title: 'HIMRA - ÇA GLOW', youtube_id: '9_esOJNo7tA' },
  # Similaire à Snoop Dogg (West Coast Hip Hop) - Artiste différent
  { title: 'Eminem - Lose Yourself', youtube_id: '_Yhyp-_hX2s' },
  # Similaire à Geto Boys (Southern Hip Hop) - Artiste différent
  { title: 'OutKast - Ms. Jackson', youtube_id: 'EUVo8epKwv0' },
  # Similaire à dannyebtracks (Type Beat) - Beat différent
  { title: 'Hip Hop Type Beat, Trap Type Beat ("flow") dannyebtracks', youtube_id: 'lwvoRUDz7Ww' },
  # Similaire à Cruel Santino (Alternative Hip Hop) - Artiste différent
  { title: 'Tyler, The Creator - EARFQUAKE', youtube_id: '40mssPDJodE' },
  # Similaire à Joyner Lucas (Conscious Hip Hop) - Artiste différent
  { title: 'J. Cole - No Role Modelz', youtube_id: 'Kb-0Eo0Yk0o' },
  # Similaire à Manu Crooks & Anfa Rose (Afro Hip Hop) - Artiste différent
  { title: 'Burna Boy - Last Last', youtube_id: '421w1j87fEM' },
  # Similaire à Mary J. Blige (R&B/Soul) - Artiste différent
  { title: 'Alicia Keys - No One', youtube_id: 'rywUS-ohqeE' },
  # Similaire à S Dott (Hip Hop) - Artiste différent
  { title: 'Kendrick Lamar - HUMBLE.', youtube_id: 'tvTRZJ-4EyI' },
  # Similaire à Sally Green (Alternative) - Artiste différent
  { title: 'Lorde - Royals', youtube_id: 'nlcIKh6s9tU' }
]

challenge_reward_videos_2.each do |video|
  challenge_reward_playlist_2.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Note: Les Challenge Reward Playlists sont maintenant gérées uniquement comme des récompenses
# Elles n'apparaissent pas dans la page des playlists du jeu, mais uniquement dans :
# - Les récompenses de l'utilisateur
# - Le profil de l'utilisateur
# - Le système de récompenses aléatoires (3 badges = Challenge)

# Challenge Reward Playlist 3
challenge_reward_playlist_3 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist 3') do |playlist|
  playlist.description = 'Troisième playlist exclusive débloquée via les récompenses challenge.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_3 = [
  { title: 'Teddy Pendergrass - Believe in Love', youtube_id: 'dQw4w9WgXcQ' },
  { title: 'toni armani- Sooner or Later', youtube_id: '9bZkp7q19f0' },
  { title: 'odunsi - Alté Cruise', youtube_id: 'kJQP7kiw5Fk' },
  { title: 'Jackboys 2000excursion ', youtube_id: 'NUsoVlDFqZg' },
  { title: 'Travis Scott - Dumbo', youtube_id: 'p47fEXGabaY' },
  { title: 'Adriano - Niska', youtube_id: 'wnJ6LuUFpMo' },
  { title: 'Coi Leray - No More Parties', youtube_id: 'qGKrc3A6HHM' },
  { title: 'HIMRA - Nouveau Boss', youtube_id: 't4H_Zoh7G5A' },
  { title: 'Yimaye - O\'Kennet', youtube_id: 'r9Ey0xD9YO0' },
  { title: '4batz - WYA', youtube_id: 't_jHrUE5IOk' }
]

challenge_reward_videos_3.each do |video|
  challenge_reward_playlist_3.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Challenge Reward Playlist 4
challenge_reward_playlist_4 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist 4') do |playlist|
  playlist.description = 'Quatrième playlist exclusive débloquée via les récompenses challenge.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_4 = [
  { title: 'Young Thug - i don\'t believe', youtube_id: '2YvMfHKdQgA' },
  { title: 'Werenoi - Tu connais', youtube_id: '35RQgMvjpLA' },
  { title: 'Lil wayne - Written History', youtube_id: '5xbjWBwtEQ4' },
  { title: 'Teddy Pendregrass - I am who i am', youtube_id: 'bE7apZSC2iI' },
  { title: 'Wiz khalifa - 5 star', youtube_id: 'mLVYwb933ls' },
  { title: 'Latto - Somebody', youtube_id: 'qB7kLilZWwg' },
  { title: 'Doja cat - Agora Hills', youtube_id: '0c66ksfigtU' },
  { title: 'Kameron carter - Rari', youtube_id: 'cGTvegayqgM' },
  { title: 'Himra - Diamants et de l\'or', youtube_id: 'YzhPpbV_E7U' },
  { title: 'Travis Scott - Hooch', youtube_id: 'P6PXqRTpTo4' }
]

challenge_reward_videos_4.each do |video|
  challenge_reward_playlist_4.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Challenge Reward Playlist 5
challenge_reward_playlist_5 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist 5') do |playlist|
  playlist.description = 'Cinquième playlist exclusive débloquée via les récompenses challenge.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_5 = [
  { title: 'janet - that\'s the way love goes', youtube_id: '2b_KfAGiglc' },
  { title: 'Calvin harris - slide', youtube_id: '8Ee4QjCEHHc' },
  { title: 'Mozzy - never tell em shit', youtube_id: 'OeJ3U0qI_eY' },
  { title: 'Koxo - Step by step', youtube_id: '0t7WbUz-q9Q' },
  { title: 'Larry June - on the unda', youtube_id: 'wpX0rzhmskg' },
  { title: 'Octavian - little', youtube_id: 'AuZxccRqB5M' },
  { title: 'Aretha Franklin - Every girl', youtube_id: 'wsK4uU_6Ec4' },
  { title: 'Yesterday - Hamza', youtube_id: '4dKbpBeoVaI' },
  { title: '4h44 - ZZ et timar', youtube_id: 'QbgdoKDZA0Y' },
  { title: 'Soleil Bleu - Bleu soleil', youtube_id: 'nd8RD3tjNQE' },
  { title: 'charger- Triangle des bermudes', youtube_id: '8p7dQGEkHPk' }
]

challenge_reward_videos_5.each do |video|
  challenge_reward_playlist_5.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Challenge Reward Playlist Alternative 6
challenge_reward_playlist_6 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist Alternative 6') do |playlist|
  playlist.description = 'Sixième playlist exclusive débloquée via les récompenses challenge - Versions alternatives et acoustiques.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_6 = [
  { title: 'Young Thug - Halftime [Acapella - Vocals Only]', youtube_id: '9251S1YusZQ' },
  { title: 'Tu connais (Instrumental)', youtube_id: 'py6fNZ8vcRs' },
  { title: 'Got Money (Acapella)', youtube_id: 'DDfTxqdi2WU' },
  { title: 'Backing Track officiel', youtube_id: 'XfeRVI1uqfM' },
  { title: 'See You Again (Vocals Only)', youtube_id: 'gFp8ovsgv-w' },
  { title: 'Somebody (Instrumental)', youtube_id: '41yvBu1kXxI' },
  { title: 'Agora Hills (Instrumental)', youtube_id: '6x26CVaJulE' },
  { title: 'Rari - TikTok performances', youtube_id: '9251S1YusZQ' }, 
  { title: 'Himra - Diamants et de l\'or (Clip officiel)', youtube_id: '2G2BjeBrjuk' },
  { title: '90210 Acapella HQ', youtube_id: '6y1XGc_x4UA' }
]

challenge_reward_videos_6.each do |video|
  challenge_reward_playlist_6.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Challenge Reward Playlist Alternative 7
challenge_reward_playlist_7 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist Alternative 7') do |playlist|
  playlist.description = 'Septième playlist exclusive débloquée via les récompenses challenge - Versions alternatives et acoustiques.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_7 = [
  { title: 'Janet - That\'s the Way Love Goes (Studio Acapella)', youtube_id: 'BKHei0FZlUk' },
  { title: 'Slide (Instrumental)', youtube_id: 'ejl5Dh1wEng' },
  { title: 'Never Tell Em Shit (Instrumental officiel)', youtube_id: 'b1ynGxdIR2g' },
  { title: 'Step by Step (Extended Version)', youtube_id: 'BhFNnjzic3o' },
  { title: 'On The Unda Acapella', youtube_id: 'pal4em79IKI' },
  { title: 'Papi Chulo (Acoustic Karaoke)', youtube_id: 'K_qqnlzChf4' },
  { title: 'A Natural Woman (Acapella)', youtube_id: '1UxctZwjuv0' },
  { title: 'Hamza - Yesterday (Clip officiel)', youtube_id: '4dKbpBeoVaI' },
  { title: '4h44 - ZZ et Timar (Clip officiel)', youtube_id: 'QbgdoKDZA0Y' },
  { title: 'Bleu Soleil (Karaoké version avec backing vocals)', youtube_id: 'DeyNHOqbeaA' }
]

challenge_reward_videos_7.each do |video|
  challenge_reward_playlist_7.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Challenge Reward Playlist Alternative 8
challenge_reward_playlist_8 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist Alternative 8') do |playlist|
  playlist.description = 'Huitième playlist exclusive débloquée via les récompenses challenge - Versions alternatives et acoustiques.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_8 = [
  { title: 'Teddy Pendergrass Love T.K.O. Acapella Performance', youtube_id: 'wEiJ56GAhQ8' },
  { title: 'Sooner or Later (Accapella) Performed Live', youtube_id: 'wEiJ56GAhQ8' },
  { title: 'Boiler Room Lagos – Live Performance', youtube_id: 'njBrMQDBmFk' },
  { title: 'Instrumental Reproduced', youtube_id: '6tmXNZwLLKQ' },
  { title: 'Dumbo (Instrumental) Accurate Version', youtube_id: '4hQ3GiQXrJ0' },
  { title: 'NISKA - 44 (Acapella)', youtube_id: 'zt9RHrGpkBE' },
  { title: 'No More Parties Acapella', youtube_id: 'xoq82JGVRJ8' },
  { title: 'Booska Boss (Instrumental)', youtube_id: 'KVf4vV676lg' },
  { title: 'Yimaye Lyrics Edit', youtube_id: 'n7tBsh68O6s' },
  { title: 'WYA (feat. Sexyy Red)', youtube_id: 'J8Lz-1wTMi8' }
]

challenge_reward_videos_8.each do |video|
  challenge_reward_playlist_8.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end

# Challenge Reward Playlist Alternative 9
challenge_reward_playlist_9 = Playlist.find_or_create_by!(title: 'Challenge Reward Playlist Alternative 9') do |playlist|
  playlist.description = 'Neuvième playlist exclusive débloquée via les récompenses challenge - Versions alternatives et acoustiques.'
  playlist.genre = 'Challenge'
  playlist.premium = true
  playlist.exclusive = true
  playlist.hidden = true  # Ne pas afficher dans la page des playlists
end

challenge_reward_videos_9 = [
  { title: 'HIMRA – Ça Glow (Visualizer)', youtube_id: 'y4V56cyd_jU' },
  { title: 'Lose Yourself Acapella (Vocals Only)', youtube_id: 'cEOKtOd_5iQ' },
  { title: 'Ms. Jackson (Instrumental)', youtube_id: 'yAZW0AhTyLo' },
  { title: 'Genesis – Trap Beat (Prod. Danny E.B)', youtube_id: '5sEUXN2-3sM' },
  { title: 'EARFQUAKE Acapella HQ', youtube_id: 'zcNgoQz7cww' },
  { title: 'No Role Modelz (Instrumental Beat Only)', youtube_id: '1CbKr7Ni0Ac' },
  { title: 'Last Last Instrumental', youtube_id: 'q8LLrUGF2NU' },
  { title: 'No One Acoustic Version', youtube_id: '3V4QyGjqOlk' },
  { title: 'HUMBLE. Acapella (Vocals Only)', youtube_id: 'AKFreeg_DlQ' },
  { title: 'Royals – Pentatonix (A cappella Cover)', youtube_id: 'E9XQ2MdNgKY' }
]

challenge_reward_videos_9.each do |video|
  challenge_reward_playlist_9.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
    v.title = video[:title]
  end
end
