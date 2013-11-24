class UsersController < ApplicationController
  require 'open-uri'
  require 'json'

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

  def verify
    user_id = cookies.signed[:user_c]

    if user_id.nil?
      render json: {success: false}
    elsif not user_signed_in? or current_user.id != user_id
      if user_signed_in?
        sign_out current_user
      end

      user = User.find(user_id)
      if user
        sign_in user
        render json: {success: true, email: current_user.email, name: current_user.name}
      else
        render json: {success: false}
      end
    else
      render json: {success: true, email: current_user.email, name: current_user.name}
    end

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
    if not user_signed_in?
      render json: {
        success: false,
        message: "No user logged in"
      }
    else
      render json: {
        success: true,
        profile: current_user.profile.to_hash
      }
    end
  end

  def google_info(access_token)
    "https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{access_token}"
  end

  def facebook_info(access_token)
    "https://graph.facebook.com/me?access_token=#{access_token}"
  end

end
