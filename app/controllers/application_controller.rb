class ApplicationController < ActionController::Base
  # Protection CSRF explicite
  protect_from_forgery with: :exception
  
  # Gestion de la langue
  before_action :set_locale
  
  # Rafraîchir la session pour éviter les déconnexions sur mobile
  before_action :refresh_session_if_needed
  
  # Gestion des erreurs d'authentification pour les requêtes AJAX
  rescue_from Devise::FailureApp, with: :handle_authentication_failure
  
  def set_locale
    # Priorité: paramètre URL > session > Accept-Language header > défaut (fr)
    locale = params[:locale] || session[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
    locale = locale.to_sym
    
    # Vérifier que la langue est disponible
    locale = I18n.default_locale unless I18n.available_locales.include?(locale)
    
    I18n.locale = locale
    session[:locale] = locale
  end
  
  def extract_locale_from_accept_language_header
    return nil unless request.env['HTTP_ACCEPT_LANGUAGE']
    
    # Extraire la langue du header Accept-Language
    lang = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    lang == 'en' ? :en : :fr
  end

  def change_locale
    locale = params[:locale].to_sym
    if I18n.available_locales.include?(locale)
      I18n.locale = locale
      session[:locale] = locale
    end
    redirect_back(fallback_location: root_path)
  end

  def default_url_options
    super.merge(locale: I18n.locale)
  end

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
  
  private
  
  # Rafraîchir la session pour éviter les déconnexions, surtout sur mobile
  def refresh_session_if_needed
    # Ne rafraîchir que si l'utilisateur est connecté et que c'est une requête GET ou POST
    if user_signed_in? && (request.get? || request.post?)
      # Toucher la session pour la maintenir active
      session[:last_activity] = Time.current.to_i
    end
  end
  
  # Gérer les erreurs d'authentification pour les requêtes AJAX
  def handle_authentication_failure(exception)
    if request.format.json? || request.headers['Accept']&.include?('application/json')
      render json: { 
        error: "Votre session a expiré. Veuillez vous reconnecter.",
        requires_auth: true,
        redirect: new_user_session_path
      }, status: :unauthorized
    else
      # Comportement par défaut de Devise
      redirect_to new_user_session_path, alert: "Votre session a expiré. Veuillez vous reconnecter."
    end
  end
end
