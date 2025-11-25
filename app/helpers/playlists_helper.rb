module PlaylistsHelper
  def playlist_translation_key(playlist)
    playlist.title.to_s.parameterize(separator: '_')
  end

  def translated_playlist_description(playlist)
    key = playlist_translation_key(playlist)
    I18n.t("playlists.descriptions.#{key}", default: playlist.description)
  end
end
