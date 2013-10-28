require 'spec_helper'

describe Users::OmniauthCallbacksController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    User.create!(name: "John Doe",
      provider: "facebook",
      uid: "1234",
      email: "dont@mail.me",
      password: Devise.friendly_token[0,20]
      )
    User.create!(name: "Jane Doe",
      provider: "google_oauth2",
      uid: "2222",
      email: "dont2@mail.me",
      password: Devise.friendly_token[0,20]
      )
    @user = double(User)
    @user.stub(:persisted?).and_return(false)
    @user.stub(:name).and_return("Jane Doe")
    @user.stub(:provider).and_return("google_oauth2")
    @user.stub(:email).and_return("dont2@mail.me")
  end

  describe "facebook login" do

    it "should successfully login and redirect to homepage when logging in with facebook" do
      user = User.where(uid: "1234").first
      User.stub(:find_for_facebook_oauth).and_return(user)
      get :facebook
      response.should redirect_to root_url
    end

    it "should register new user" do
      User.stub(:find_for_facebook_oauth).and_return(@user)
      get :facebook
    end
  end

  describe "google login" do
    it "should successfully login and redirect to homepage when logging in with google" do
      user = User.where(uid: "2222").first
      User.stub(:find_for_google_oauth2).and_return(user)
      get :google_oauth2
      response.should redirect_to root_url
    end

    it "should register new user" do
      User.stub(:find_for_google_oauth2).and_return(@user)
      get :google_oauth2
    end
  end


end