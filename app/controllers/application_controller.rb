class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_csrf_cookie_for_ng
  before_filter :try_cookie_login, :require_login

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def require_login
    unless user_signed_in?
      render json: {
        success: false,
        message: "No user logged in"
      }
      return false
    end
  end

  def try_cookie_login
    if not user_signed_in? and cookies.signed[:user_c]
      user_id = cookies.signed[:user_c]
      user = User.find(user_id)
      sign_in user if user
    end
  end

  protected

    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end

end
