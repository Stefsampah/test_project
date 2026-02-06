class PostsController < ApplicationController
  def index
    @posts = Post.published.in_locale(I18n.locale).order(published_at: :desc)
  end

  def show
    @post = find_post
  end

  private

  def find_post
    scope = Post.published.in_locale(I18n.locale)
    scope.find_by!(slug: params[:id])
  rescue ActiveRecord::RecordNotFound
    scope.find(params[:id])
  end
end
