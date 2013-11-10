class UsersController < ApplicationController
  require 'open-uri'
  require 'json'

  def authenticate
    provider = params[:provider]
    access_token = params[:access]
    uri = URI(self.send("#{provider}_info".to_sym, access_token))
    user_info = JSON.parse(uri.read, symbolize_names: true)
    user = User.find_by_provider(user_info, provider)
    login(user.email, user)
  end

  def destroy_session
    email = params[:email]
    user = User.find_by_email(email)
    sign_out user
    render json: {}
  end

  private

  def login(email, user = nil)
    @user = user
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
