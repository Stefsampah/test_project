class FeedPlaylistsService
  # Construit un feed 60/40 pour les playlists standard d'un utilisateur.
  #
  # Règles simples :
  # - 60 % des playlists viennent de catégories déjà jouées par l'utilisateur
  # - 40 % des playlists viennent de nouvelles catégories
  # - On ne perd aucune playlist : les restantes sont ajoutées à la fin, dans l'ordre original
  #
  # Paramètres :
  # - user: User (doit être connecté)
  # - playlists_scope: ActiveRecord::Relation ou Array<Playlist>
  def self.standard_feed(user, playlists_scope)
    return playlists_scope.to_a unless user && playlists_scope

    playlists = playlists_scope.respond_to?(:to_a) ? playlists_scope.to_a : Array(playlists_scope)
    return playlists if playlists.size <= 3 # inutile de sur-optimiser pour très peu d'éléments

    played_playlist_ids = user.scores.pluck(:playlist_id)
    familiar_categories = Playlist.where(id: played_playlist_ids).pluck(:category).compact.uniq

    familiar, unfamiliar = playlists.partition { |p| familiar_categories.include?(p.category) }

    total = playlists.size
    desired_familiar = (total * 0.6).round
    desired_unfamiliar = (total * 0.4).round

    chosen_familiar = familiar.first(desired_familiar)

    remaining = playlists - chosen_familiar
    remaining_unfamiliar = remaining & unfamiliar
    chosen_unfamiliar = remaining_unfamiliar.first(desired_unfamiliar)

    feed_core = (chosen_familiar + chosen_unfamiliar).uniq
    rest = playlists - feed_core

    feed_core + rest
  end
end

