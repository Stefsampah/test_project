class SitemapController < ApplicationController
  # Pas besoin d'authentification pour le sitemap
  skip_before_action :verify_authenticity_token
  
  def index
    @base_url = "https://www.tubenplay.com"
    @playlists = Playlist.all
    @posts = Post.published
    @last_modified = [
      @playlists.maximum(:updated_at),
      Playlist.maximum(:created_at),
      @posts.maximum(:updated_at)
    ].compact.max || Time.current
    
    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end

