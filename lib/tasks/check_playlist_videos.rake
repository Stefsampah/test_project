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
  end
end
