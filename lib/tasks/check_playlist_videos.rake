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
end
