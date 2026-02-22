# Liste les vidéos d'une playlist et optionnellement vérifie si elles sont encore disponibles sur YouTube.
# Usage:
#   rails check_playlist_videos:list[21]                    # playlist id 21
#   rails check_playlist_videos:list[21] check               # avec vérification YouTube
#   rails "check_playlist_videos:list[21,check]"             # idem (syntaxe selon shell)
namespace :check_playlist_videos do
  desc "Liste les vidéos d'une playlist. Option: check = vérifier disponibilité YouTube (ex: rails check_playlist_videos:list[21] ou rails check_playlist_videos:list[21,check])"
  task :list, [:playlist_id, :check] => :environment do |_t, args|
    raw = (args[:playlist_id] || args[:playlist_id].to_s).to_s
    parts = raw.split(",").map(&:strip)
    playlist_id = parts[0]
    do_check = (parts[1] || args[:check].to_s).to_s.downcase == "check"
    if playlist_id.blank?
      puts "Usage: rails check_playlist_videos:list[PLAYLIST_ID] ou rails check_playlist_videos:list[PLAYLIST_ID,check]"
      next
    end
    playlist = Playlist.find_by(id: playlist_id)
    unless playlist
      puts "Playlist ##{playlist_id} introuvable."
      next
    end
    videos = playlist.videos.order(:id)
    puts "Playlist: #{playlist.title} (id=#{playlist.id}) — #{videos.size} vidéo(s)"
    puts "-" * 80
    videos.each_with_index do |v, i|
      status = if do_check
        CheckYoutubeVideoService.available?(v.youtube_id) ? "✅ OK" : "❌ Indisponible"
      else
        ""
      end
      puts "#{(i + 1).to_s.rjust(3)} | #{v.youtube_id.ljust(12)} | #{v.title.truncate(50).ljust(50)} #{status}"
    end
    if do_check
      ok = videos.count { |v| CheckYoutubeVideoService.available?(v.youtube_id) }
      puts "-" * 80
      puts "Résumé: #{ok}/#{videos.size} vidéo(s) encore disponibles."
    end
  end

  desc "Liste TOUTES les vidéos indisponibles (YouTube) de toutes les playlists. Pour les remplacer en base."
  task all_unavailable: :environment do
    puts "Vérification de toutes les playlists..."
    puts "=" * 90
    total_ok = 0
    total_ko = 0
    list_ko = []
    Playlist.order(:id).find_each do |playlist|
      videos = playlist.videos.order(:id)
      next if videos.empty?
      videos.each_with_index do |v, i|
        if CheckYoutubeVideoService.available?(v.youtube_id)
          total_ok += 1
        else
          total_ko += 1
          list_ko << {
            playlist_id: playlist.id,
            playlist_title: playlist.title,
            position: i + 1,
            video_id: v.id,
            youtube_id: v.youtube_id,
            title: v.title
          }
        end
      end
    end
    puts "\nRÉSUMÉ GLOBAL: #{total_ok} vidéo(s) OK, #{total_ko} vidéo(s) indisponibles\n"
    if list_ko.empty?
      puts "Aucune vidéo indisponible. Rien à remplacer."
      next
    end
    puts "\n" + "=" * 90
    puts "VIDÉOS INDISPONIBLES À REMPLACER (à supprimer ou remplacer en base)"
    puts "=" * 90
    list_ko.each do |h|
      puts "\nPlaylist ##{h[:playlist_id]} — #{h[:playlist_title]}"
      puts "  Position: #{h[:position]} | Video ID (DB): #{h[:video_id]} | YouTube ID: #{h[:youtube_id]}"
      puts "  Titre: #{h[:title]}"
      puts "  → Supprimer: Video.find(#{h[:video_id]}).destroy"
      puts "  → Ou remplacer youtube_id/title en conservant l'id #{h[:video_id]}"
    end
    puts "\n" + "=" * 90
    puts "Total: #{list_ko.size} vidéo(s) indisponibles dans #{list_ko.map { |h| h[:playlist_id] }.uniq.size} playlist(s)"
    puts "\nExemple pour tout supprimer en console Rails:"
    puts "  Video.where(youtube_id: [#{list_ko.map { |h| "'#{h[:youtube_id]}'" }.join(', ')}]).destroy_all"
    puts "\nOu lancer la tâche: rake check_playlist_videos:destroy_all_unavailable"
  end

  # Supprime en base toutes les vidéos détectées comme indisponibles par all_unavailable.
  # À lancer sur Heroku après avoir vérifié la liste: heroku run "rake check_playlist_videos:destroy_all_unavailable" --app tubenplay-app
  desc "Supprime toutes les vidéos indisponibles (YouTube) de la base"
  task destroy_all_unavailable: :environment do
    ids = []
    Playlist.order(:id).find_each do |playlist|
      playlist.videos.order(:id).each do |v|
        ids << v.youtube_id unless CheckYoutubeVideoService.available?(v.youtube_id)
      end
    end
    if ids.empty?
      puts "Aucune vidéo indisponible. Rien à supprimer."
      next
    end
    count = Video.where(youtube_id: ids).count
    Video.where(youtube_id: ids).destroy_all
    puts "✅ #{count} vidéo(s) indisponibles supprimées (youtube_id: #{ids.join(', ')})"
  end

  # Remplace les vidéos indisponibles par les nouvelles valeurs définies dans config/replace_unavailable_videos.yml
  # Remplis new_youtube_id et new_title pour chaque vidéo à remplacer, puis lance :
  #   heroku run "rake check_playlist_videos:replace_unavailable" --app tubenplay-app
  desc "Remplace les vidéos indisponibles selon config/replace_unavailable_videos.yml"
  task replace_unavailable: :environment do
    path = Rails.root.join("config", "replace_unavailable_videos.yml")
    unless File.exist?(path)
      puts "❌ Fichier absent: config/replace_unavailable_videos.yml"
      puts "   Lance d'abord: rails check_playlist_videos:export_replace_template pour le générer."
      next
    end
    data = YAML.load_file(path)
    list = data["replacements"] || data[:replacements] || []
    if list.empty?
      puts "Aucun remplacement défini dans le YAML."
      next
    end
    updated = 0
    skipped = 0
    list.each do |h|
      vid = h["video_id"] || h[:video_id]
      new_id = (h["new_youtube_id"] || h[:new_youtube_id]).to_s.strip
      new_title = (h["new_title"] || h[:new_title]).to_s.strip
      next if new_id.blank?
      video = Video.find_by(id: vid)
      unless video
        puts "⚠️ Video ##{vid} introuvable, ignoré."
        next
      end
      if CheckYoutubeVideoService.available?(new_id)
        video.update!(youtube_id: new_id, title: new_title.presence || video.title)
        puts "✅ Video ##{vid} (#{video.playlist.title}) → #{new_id} | #{new_title.presence || video.title}"
        updated += 1
      else
        puts "⚠️ Le nouveau YouTube ID #{new_id} n'est pas disponible, ignoré pour Video ##{vid}."
        skipped += 1
      end
    end
    puts "\n✅ #{updated} vidéo(s) remplacée(s)."
    puts "⚠️ #{skipped} ignorée(s) (nouvel ID indisponible)." if skipped > 0
  end

  # Génère le fichier config/replace_unavailable_videos.yml à partir des vidéos actuellement indisponibles
  desc "Génère config/replace_unavailable_videos.yml avec les vidéos indisponibles (à compléter puis replace_unavailable)"
  task export_replace_template: :environment do
    path = Rails.root.join("config", "replace_unavailable_videos.yml")
    list = []
    Playlist.order(:id).find_each do |playlist|
      playlist.videos.order(:id).each_with_index do |v, i|
        next if CheckYoutubeVideoService.available?(v.youtube_id)
        list << {
          "video_id" => v.id,
          "playlist" => playlist.title,
          "old_youtube_id" => v.youtube_id,
          "old_title" => v.title,
          "new_youtube_id" => "",
          "new_title" => ""
        }
      end
    end
    File.write(path, { "replacements" => list }.to_yaml)
    puts "✅ Fichier écrit: config/replace_unavailable_videos.yml (#{list.size} vidéos à remplacer)"
  end
end
