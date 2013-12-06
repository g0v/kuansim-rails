class UsersController < ApplicationController
  require 'open-uri'
  require 'json'

  skip_before_filter :require_login, except: [:follow_issue, :follows_issue?, :get_user_events_by_issue]

  skip_before_filter :try_cookie_login, only: [:authenticate, :login]

  before_filter :need_id, only: [:follow_issue, :follows_issue?]

  # Going to set user image each login (in case image changes)
  def authenticate
    provider = params[:provider]
    access_token = params[:access]
    uri = URI.parse(self.send("#{provider}_info".to_sym, access_token))
    user_info = JSON.parse(uri.read)
    @user = User.find_by_provider(user_info, provider)
    cookies.permanent.signed[:user_c] = @user.id
    login(@user.email)
  end

  # Thanks to try_cookie_login before filter in application controller
  # it already tried to log in with the cookie, so just check if there is
  # a user logged in and return the username
  def verify
    success = user_signed_in?
    name = (success) ? current_user.name : ""
    email = (success) ? current_user.email : ""

    render json: {
      success: success,
      name: name,
      email: email
    }

  end

  def follow_issue
    issue = Issue.find(params[:id])
    if issue
      followed_issues = current_user.followed_issues
      followed_issues << issue
      render json: { success: true }
    else
      render json: {
        success: false,
        message: "Cannot follow nonexistent issue"
      }
    end
  end

  def follows_issue?
    render json: {
      success: true,
      follows: current_user.follows_issue?(Issue.find(params[:id]))
    }
  end

  def destroy_session
    if user_signed_in?
      sign_out current_user
      cookies.delete :user_c
    end
    render json: {success: true}
  end

  def login(email)
    if @user
      sign_in @user, :event => :authentication
    else
      @user = User.find_by_email(email)
      sign_in @user, :event => :authentication
    end
    render json: {name: @user.name, email: @user.email}
  end

  def current_profile
    render json: {
      success: true,
      profile: current_user.profile.to_hash
    }
  end

  def google_info(access_token)
    "https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{access_token}"
  end

  def facebook_info(access_token)
    "https://graph.facebook.com/me?access_token=#{access_token}"
  end

  def get_user_events_by_issue
    json_reply = {success: true}
    events = []
    u_id = params[:id]
    i_id = params[:issue_id]
    if !is_int? u_id or !is_int? i_id
      json_reply[:success] = false
      json_reply[:message] = "A user_id and issue_id must be provided."
    else
      events = User.find(u_id).events.select{ |e| e.issues.include?(Issue.find(i_id)) }
      json_reply[:message] = "Events of the given user that are associated with the given issue were returned."
    end
    json_reply[:events] = events
    render json: json_reply
  end

  private
    def is_int?(str)
      return ((str != "0" and str.to_i != 0) or str == "0")
    end

    def require_login
      if not user_signed_in?
        render json: {
          success: false,
          message: "No user logged in"
        }
        return false
      end
      true
    end
end
