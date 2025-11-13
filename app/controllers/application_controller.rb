class ApplicationController < ActionController::Base
  # Protection CSRF explicite
  protect_from_forgery with: :exception

  def sign_out_redirect
    # Utiliser sanitize au lieu de html_safe pour plus de sécurité
    render html: sanitize("
      <form id='signout-form' method='post' action='#{destroy_user_session_path}'>
        <input name='_method' type='hidden' value='delete' />
        <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}' />
      </form>
      <script>document.getElementById('signout-form').submit();</script>
    ")
  end
end
