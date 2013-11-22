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

  def verify
    email = params[:email]
    if current_user.nil?
      render json: {success: false, message: "No user logged in"}
    elsif current_user.email != email
      render json: {success: false, message: "Invalid email"}
    else
      render json: {success: true}
    end
  end

  def destroy_session
    email = params[:email]
    user = User.find_by_email(email)
    sign_out user
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
    if current_user.nil?
      render json: {success: false, message: "No user logged in"}
    else
      render json: {success: true, profile: {name: self.name, github: self.github}
        .merge(current_user.profile.to_hash)
      }
    end
  end

  def google_info(access_token)
    "https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{access_token}"
  end

  def facebook_info(access_token)
    "https://graph.facebook.com/me?access_token=#{access_token}"
  end

  def google_image_url(id)
    "https://plus.google.com/s2/photos/profile/#{id}"
  end

  def facebook_image_url(id)
    "https://graph.facebook.com/#{id}/?fields=picture.type(large)"
  end

end
