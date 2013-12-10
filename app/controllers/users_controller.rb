class UsersController < ApplicationController
  require 'open-uri'
  require 'json'

  skip_before_filter :try_cookie_login, only: [:authenticate, :login]

  skip_before_filter :require_login, only: [:authenticate, :verify, :login, :follow_issue, :unfollow_issue, :created_events]

  before_filter :need_id, only: [:unfollow_issue, :follow_issue, :follows_issue?, :followed_issues]
  before_filter :issue_exists, only: [:unfollow_issue, :follow_issue, :follows_issue?]

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
    id = (success) ? current_user.id : ""
    name = (success) ? current_user.name : ""
    email = (success) ? current_user.email : ""

    render json: {
      success: success,
      id: id,
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

  def unfollow_issue
    current_user.followed_issues.delete(Issue.find(params[:id]))
    render json: { success: true }
  end

  def follows_issue?
    render json: {
      success: true,
      follows: current_user.follows_issue?(params[:id])
    }
  end

  # Get followed issues of any user
  def followed_issues
    issues_list = []
    user = User.find(params[:id])
    followed_issues = user.followed_issues
    followed_issues.each do |issue|
      issues_list << {
        id: issue.id,
        title: issue.title,
        description: issue.description,
      }
    end
    render json: {
      success: true,
      issues: issues_list
    }
  end

  def recommended
    # user = current_user
    recommended_counts = Hash.new(0)
    current_user.followed_issues.each do |issue|
      issue.related_issues.each do |related|
        recommended_counts[related] += 1
      end
    end
    render json: {
      success: true,
      recommended_issues: recommended_counts.keys
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

  def created_events
    json_reply = {success: true}
    user = User.find_by_id(params[:id]);
    if (user.nil?)
      json_reply[:success] = false
      json_reply[:message] = "User does not exist."
    else
      events = user.events.map do |e|
        event = e.as_json
        event
      end
    end
    json_reply[:events] = events
    render json: json_reply
  end

  private

    def is_int?(str)
      return ((str != "0" and str.to_i != 0) or str == "0")
    end

    def google_info(access_token)
      "https://www.googleapis.com/oauth2/v2/userinfo?access_token=#{access_token}"
    end

    def facebook_info(access_token)
      "https://graph.facebook.com/me?access_token=#{access_token}"
    end

end
