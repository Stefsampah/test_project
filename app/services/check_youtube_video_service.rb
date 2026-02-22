# Vérifie si une vidéo YouTube est encore disponible (sans clé API).
# Utilise l'endpoint oembed de YouTube ; 200 = disponible, 404/autre = indisponible ou privée.
class CheckYoutubeVideoService
  OEMBED_URL = "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=%s"

  def self.available?(youtube_id)
    return false if youtube_id.blank?
    uri = URI(OEMBED_URL % CGI.escape(youtube_id.to_s))
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(request)
    end
    response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    Rails.logger.warn "CheckYoutubeVideoService #{youtube_id}: #{e.message}"
    false
  end
end
