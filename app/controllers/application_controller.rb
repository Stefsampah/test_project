class ApplicationController < ActionController::Base
  def sign_out_redirect
    render html: "
      <form id='signout-form' method='post' action='#{destroy_user_session_path}'>
        <input name='_method' type='hidden' value='delete' />
        <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}' />
      </form>
      <script>document.getElementById('signout-form').submit();</script>
    ".html_safe
  end
end
