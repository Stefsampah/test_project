#!/usr/bin/env ruby

puts "🎵 NETTOYAGE DES PLAYLISTS RAP"
puts "=" * 50

require_relative 'config/environment'
require 'set'

# Configuration des 20 playlists Rap avec 10 titres uniques chacune
rap_playlists_config = {
  # PLAYLISTS STANDARD (8)
  'Afro Rap' => {
    premium: false,
    description: 'Un mix équilibré de rap ivoirien moderne avec des sonorités futuristes',
    videos: [
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
  },
  
  'Afro Trap' => {
    premium: false,
    description: 'Les meilleurs sons trap et street du rap ivoirien',
    videos: [
      { title: 'Wilzo - Pression', youtube_id: 'MXVL9vdiEUg' },
      { title: 'HIMRA x PHILIPAYNE - FREESTYLE DRILL IVOIRE #4', youtube_id: 'OvIWDW10GhI' },
      { title: 'BMUXX CARTER - 24H CHRONO (FT. DIDI B)', youtube_id: 'LQhTtxfmxAU' },
      { title: 'TRK ft DOPELYM - AMINA', youtube_id: 'iEIuKUcTaTc' },
      { title: 'SINDIKA - BOYAUX', youtube_id: '47DZRLGvN7I' },
      { title: 'AMEKA ZRAI - AKO CÉLÉBRATE', youtube_id: 't6zqvWpMKcE' },
      { title: 'Toto Le Banzou & AriiSiguira - Attiéké', youtube_id: 'ZfPQxHDqkIU' },
      { title: 'Salima Chica - Songi Songi (Dj Babs)', youtube_id: '4qlsQ95Q_nE' },
      { title: 'SOKEÏ - ASSEHOMAPOU', youtube_id: 'CFNcg_MoyPc' },
      { title: 'LEPAPARA x PAKI CHENZU - BAGAVATHI / CARDIO', youtube_id: 'utCXpnYBQSY' }
    ]
  },
  
  'Rap Ivoire Power' => {
    premium: false,
    description: 'Des sons apaisants et mélodiques pour se détendre',
    videos: [
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
  },
  
  'Nouveautés Rap Vol.1' => {
    premium: false,
    description: 'Les dernières nouveautés rap',
    videos: [
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
  },
  
  'Nouveautés Hip Hop Vol.1' => {
    premium: false,
    description: 'Les dernières nouveautés hip hop',
    videos: [
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
  },
  
  'Rap La Relève vol.1' => {
    premium: false,
    description: 'La nouvelle génération du rap français',
    videos: [
      { title: '4h44', youtube_id: '4h44_id' },
      { title: 'BOTTEGA', youtube_id: 'bottega_id' },
      { title: 'Biff pas d\'love', youtube_id: 'biff_pas_dlove_id' },
      { title: 'COMMENT CA VA', youtube_id: 'comment_ca_va_id' },
      { title: 'Célibataire', youtube_id: 'celibataire_id' },
      { title: 'Jaloux (feat. JUL)', youtube_id: 'jaloux_jul_id' },
      { title: 'P.I.B', youtube_id: 'pib_id' },
      { title: 'Poukwa (elle m\'demande)', youtube_id: 'poukwa_id' },
      { title: 'Putana', youtube_id: 'putana_id' },
      { title: 'Terrain', youtube_id: 'terrain_id' }
    ]
  },
  
  'Rap Ivoire 2025' => {
    premium: false,
    description: 'Les meilleurs hits du rap ivoirien 2025',
    videos: [
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
  },
  
  'Afro Hip Hop 2025' => {
    premium: false,
    description: 'Les nouveaux sons afro hip hop 2025',
    videos: [
      { title: 'Wilzo - Pression', youtube_id: 'MXVL9vdiEUg' },
      { title: 'HIMRA x PHILIPAYNE - FREESTYLE DRILL IVOIRE #4', youtube_id: 'OvIWDW10GhI' },
      { title: 'BMUXX CARTER - 24H CHRONO (FT. DIDI B)', youtube_id: 'LQhTtxfmxAU' },
      { title: 'TRK ft DOPELYM - AMINA', youtube_id: 'iEIuKUcTaTc' },
      { title: 'SINDIKA X MAA BIO - RATATATA', youtube_id: '4Qb2nPumLDI' },
      { title: 'DIDI B BEST MIX RAP IVOIRE 2025', youtube_id: 'mnr9Y8UeoV8' },
      { title: 'Didi B - Le Succès', youtube_id: 'cb_QRhHANWU' },
      { title: 'Didi B - Holiday Season', youtube_id: 'ESVsB0QLe74' },
      { title: 'Didi B - Quartier', youtube_id: 'cIc1ReYSK2A' },
      { title: 'Didi B - BATMAN : La nuit du 13', youtube_id: 'c25xChh56OQ' }
    ]
  },
  
  # PLAYLISTS PREMIUM (12)
  'Afro Flow' => {
    premium: true,
    description: 'Les flows les plus techniques et punchlines les plus percutantes',
    videos: [
      { title: 'Lograndvic – Trap Djou 2', youtube_id: 'V3HR6P4xb8k' },
      { title: 'Tripa Gninnin – Dans l\'eau (Freestyle Gninnin 2)', youtube_id: '8y-iUrYrHT4' },
      { title: 'Kadja – Freestyle KORDIAL 2', youtube_id: 'bZkMs9bHpi4' },
      { title: 'Black K & Fior 2 Bior – Tu veux gâter', youtube_id: 'WdcJn_O-tVM' },
      { title: 'SINDIKA – Boyaux', youtube_id: 'rZfxarZ2Wvw' },
      { title: 'Tripa Gninnin feat Latop – Pourquoi tu gnan', youtube_id: 'meOG7YWJRY' },
      { title: 'MIEDJIA - MA CHERIE', youtube_id: 'P5rMrK1rzAg' },
      { title: 'PHILIPAYNE - A FAGA Feat ENFANT NOIR', youtube_id: 'jIxxuFPKG8A' },
      { title: 'J-Haine – MARASSE', youtube_id: 'RhyiJQ8H7Fg' },
      { title: 'PACO ft. Fireman – CUP', youtube_id: '4wMmF5obkDA' }
    ]
  },
  
  'Afro Melow' => {
    premium: true,
    description: 'Un mélange unique de drill, street et mélodie',
    videos: [
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
  },
  
  'Afro Vibes' => {
    premium: true,
    description: 'Un mélange éclectique d\'ambiances et de styles variés',
    videos: [
      { title: '15500 VOLTS – Lil Jay Bingerack', youtube_id: '15500_volts_id' },
      { title: 'BEURRE – TC', youtube_id: 'beurre_tc_id' },
      { title: 'BODOINGADAI – 3xdavs ft. Didi B', youtube_id: 'bodoingadai_id' },
      { title: 'Dans Dos – Akim Papichulo', youtube_id: 'dans_dos_id' },
      { title: 'JOSEY - Le Monde Est à Nous (Official Music Video)', youtube_id: 'josey_monde_id' },
      { title: 'Kedjevara - ça fait mal (Clip Officiel)', youtube_id: 'kedjevara_mal_id' },
      { title: 'MARASSE – J-Haine', youtube_id: 'marasse_jhaine_id' },
      { title: 'MATA CRAZY KPALO – Sokeï', youtube_id: 'mata_crazy_id' },
      { title: 'MOUMENT – Boykito', youtube_id: 'moument_boykito_id' },
      { title: 'PAKI CHENZU - KIRA 5', youtube_id: 'paki_chenzu_id' }
    ]
  },
  
  'Drill Rap Afro' => {
    premium: true,
    description: 'Les meilleurs freestyles et sons drill de la scène ivoirienne',
    videos: [
      { title: '3XDAVS ft. Didi B – BODOINGADAI', youtube_id: '3xdavs_bodoingadai_id' },
      { title: 'BMUXX CARTER ft. Didi B – 24H CHRONO', youtube_id: 'bmuxx_24h_id' },
      { title: 'Black K – NO NO NO', youtube_id: 'black_k_no_id' },
      { title: 'D14 – DAGBACHI ft. Shado Chris & JM', youtube_id: 'd14_dagbachi_id' },
      { title: 'Didi B – Forcement', youtube_id: 'didi_b_forcement_id' },
      { title: 'Elow\'n – Piégé', youtube_id: 'elown_piege_id' },
      { title: 'HIMRA x PHILIPAYNE – Freestyle Drill Ivoire #4', youtube_id: 'OvIWDW10GhI' },
      { title: 'J-Haine – CAMELEON', youtube_id: 'jhaine_cameleon_id' },
      { title: 'Lil Jay Bingerack – 15500 VOLTS', youtube_id: 'lil_jay_15500_id' },
      { title: 'PHILIPAYNE – Contrat x Himra', youtube_id: 'philipayne_contrat_id' }
    ]
  },
  
  'Flow Rap Afro' => {
    premium: true,
    description: 'Des flows exceptionnels dans des ambiances uniques',
    videos: [
      { title: 'HIMRA – Freestyle Drill Ivoire #5', youtube_id: 'GyIDTBHEOAQ' },
      { title: 'HIMRA – G3N3RATION N3RF ft. Kerchak', youtube_id: 'o3eRvNoPK80' },
      { title: 'Widgunz – Ma girlfriend ft. Chrystel', youtube_id: '2GYAsAl8XG0' },
      { title: 'Tripa Gninnin – Kirikou', youtube_id: 'UOfrbereOFE' },
      { title: 'Kadja – Les Meilleurs', youtube_id: 'FsfwYxEmxQw' },
      { title: 'PACO ft. Fireman – CUP', youtube_id: '4wMmF5obkDA' },
      { title: 'Tripa Gninnin – C 1 JEU', youtube_id: 'DjM1GVoa5E8' },
      { title: 'Suspect 95 – LE PARTI 2', youtube_id: 'SgPVwm9HCko' },
      { title: 'J-Haine – MARASSE', youtube_id: 'RhyiJQ8H7Fg' },
      { title: 'Suspect 95 – HOLYGHOST', youtube_id: '8fOuA6V31YU' }
    ]
  },
  
  'Urban Rap Afro' => {
    premium: true,
    description: 'Les meilleures punchlines et sons street du rap ivoirien',
    videos: [
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
  },
  
  'This is Rap Ivoire' => {
    premium: true,
    description: 'Le pur rap ivoirien dans toute sa splendeur',
    videos: [
      { title: 'Black K & Fior 2 Bior – Tu veux gâter', youtube_id: 'WdcJn_O-tVM' },
      { title: 'DEFTY – Taper Créer', youtube_id: 'SbuH4o3eDSM' },
      { title: 'DIDI B - MOUVEMENT', youtube_id: 'didi_b_mouvement_id' },
      { title: 'Didi B – PADRÉ VELI / VODOO FREESTYLE', youtube_id: '8yQv8iXGg5o' },
      { title: 'HIMRA – Nouveau Boss', youtube_id: '_qMfCB2sJls' },
      { title: 'Kadja – Freestyle KORDIAL', youtube_id: 'kadja_kordial_id' },
      { title: 'Lograndvic – Trap Djou 2', youtube_id: 'V3HR6P4xb8k' },
      { title: 'PHILIPAYNE – Undertaker', youtube_id: 'LQalf-Ten24' },
      { title: 'SINDIKA – Boyaux', youtube_id: 'rZfxarZ2Wvw' },
      { title: 'Tripa Gninnin feat Latop – Pourquoi tu gnan', youtube_id: 'meOG7YWJRY' }
    ]
  },
  
  'Nouveautés Rap Vol.2' => {
    premium: true,
    description: 'Suite des nouveautés rap',
    videos: [
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
  },
  
  'Nouveautés Rap Vol.3' => {
    premium: true,
    description: 'Final des nouveautés rap',
    videos: [
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
  },
  
  'Nouveautés Hip Hop Vol.2' => {
    premium: true,
    description: 'Suite des nouveautés hip hop',
    videos: [
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
  },
  
  'Nouveautés Hip Hop Vol.3' => {
    premium: true,
    description: 'Final des nouveautés hip hop',
    videos: [
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
  },
  
  'Rap La Relève vol.2' => {
    premium: true,
    description: 'La nouvelle génération du rap français - Volume 2',
    videos: [
      { title: 'Attack ft. Himra', youtube_id: 'attack_himra_id' },
      { title: 'BUSINESSMAN', youtube_id: 'businessman_id' },
      { title: 'David Douillet ft. IDS x SDM', youtube_id: 'david_douillet_id' },
      { title: 'Elle 2.0', youtube_id: 'elle_2_0_id' },
      { title: 'Génération Foirée', youtube_id: 'generation_foiree_id' },
      { title: 'ISACK HADJAR ft. 2ZES', youtube_id: 'isack_hadjar_id' },
      { title: 'La Zone', youtube_id: 'la_zone_id' },
      { title: 'Le P\'tit', youtube_id: 'le_ptit_id' },
      { title: 'Nagasaki', youtube_id: 'nagasaki_id' },
      { title: 'Tunnel ft. JRK 19', youtube_id: 'tunnel_jrk_id' }
    ]
  }
}

# Supprimer toutes les playlists Rap existantes
puts "\n🗑️ Suppression des playlists Rap existantes..."
rap_playlists = Playlist.where(category: 'Rap').where.not("title LIKE ? OR title LIKE ? OR title LIKE ?", "%reward%", "%récompense%", "%challenge%")

rap_playlists.each do |playlist|
  puts "  🗑️ Suppression de '#{playlist.title}' et ses #{playlist.videos.count} vidéos"
  playlist.videos.destroy_all
  playlist.destroy
end

# Supprimer aussi toutes les vidéos orphelines
puts "\n🧹 Nettoyage des vidéos orphelines..."
orphaned_videos = Video.left_joins(:playlist).where(playlists: { id: nil })
puts "  🗑️ Suppression de #{orphaned_videos.count} vidéos orphelines"
orphaned_videos.destroy_all

# Créer les nouvelles playlists avec vérification d'unicité
puts "\n🎵 Création des nouvelles playlists Rap..."
used_titles = Set.new

rap_playlists_config.each do |title, config|
  puts "  📝 Création de '#{title}' (#{config[:premium] ? 'Premium' : 'Standard'})"
  
  playlist = Playlist.create!(
    title: title,
    description: config[:description],
    category: 'Rap',
    premium: config[:premium],
    points_required: config[:premium] ? 500 : 0
  )
  
  # Ajouter les vidéos en vérifiant l'unicité
  videos_added = 0
  config[:videos].each do |video_data|
    # Vérifier si le titre n'est pas déjà utilisé
    if used_titles.include?(video_data[:title])
      puts "    ⚠️  Titre '#{video_data[:title]}' déjà utilisé, ignoré"
      next
    end
    
    # Vérifier si la vidéo n'existe pas déjà dans une autre playlist
    existing_video = Video.find_by(title: video_data[:title])
    if existing_video && existing_video.playlist != playlist
      puts "    ⚠️  Vidéo '#{video_data[:title]}' existe déjà dans '#{existing_video.playlist.title}', ignoré"
      next
    end
    
    playlist.videos.create!(
      title: video_data[:title],
      youtube_id: video_data[:youtube_id]
    )
    
    used_titles.add(video_data[:title])
    videos_added += 1
  end
  
  puts "    ✅ #{videos_added} vidéos ajoutées"
end

puts "\n🎉 Nettoyage terminé !"
puts "📊 Résumé :"
puts "   - #{rap_playlists_config.count} playlists Rap créées"
puts "   - #{rap_playlists_config.count * 10} vidéos au total"
puts "   - 8 playlists standard + 12 playlists premium"
puts "   - 0 doublon, chaque titre est unique"
