class UsersController < ApplicationController
  require 'open-uri'
  require 'json'

  def authenticate
    provider = params[:provider]
    access_token = params[:access]
    uri = URI.parse(self.send("#{provider}_info".to_sym, access_token))
    user_info = JSON.parse(uri.read)
    @user = User.find_by_provider(user_info, provider)
    login(@user.email)
  end

  def destroy_session
    email = params[:email]
    user = User.find_by_email(email)
    sign_out user
    render json: {}
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

  def google_info(access_token)
    "https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{access_token}"
  end

  def facebook_info(access_token)
    "https://graph.facebook.com/me?access_token=#{access_token}"
  end

end
