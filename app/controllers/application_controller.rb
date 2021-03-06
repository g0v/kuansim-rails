class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_csrf_cookie_for_ng
  before_filter :try_cookie_login, :require_login

  # TODO - Make filter for checking for :id parameter

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

    def need_id
      if params[:id].nil?
        render json: {
          success: false,
          message: "Id param cannot be nil"
        }
        return false
      end
    end

    def issue_exists
      unless Issue.exists?(id: params[:id])
        render json: {
          success: false,
          message: "Issue does not exist"
        }
        return false
      end
    end

end
