require 'spec_helper'

describe UsersController do

  before :each do
    @user_goog = FactoryGirl.create(:user_google)
    @user_face = FactoryGirl.create(:user_facebook)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "should successfully render json info of a valid google user" do
    uri = double(URI)
    uri.stub(:read).and_return({good: 'stuff', hey: 'yo'})
    URI.stub(:parse).and_return(uri)
    JSON.stub(:parse).and_return(@user_goog.as_json)
    User.stub(:find_by_provider).and_return(@user_goog)

    post :authenticate, provider: "google", access: "ehgalhdglskahg3"
    response.should be_success
  end

  it "should successfully render json info of a valid facebook user" do
    uri = double(URI)
    uri.stub(:read).and_return({good: 'stuff', hey: 'yo'})
    URI.stub(:parse).and_return(uri)
    JSON.stub(:parse).and_return(@user_face.as_json)
    User.stub(:find_by_provider).and_return(@user_face)

    post :authenticate, provider: "facebook", access: "ehgalhdglskahg3"
    response.should be_success
  end

  it "should successfully log out a user" do
    sign_in @user_goog
    post :destroy_session, email: @user_goog.email
    response.should be_success
  end

  describe "verify" do

    describe "with arbitrary ids" do

      before :each do
        cookies.stub(:signed).and_return({user_c: 300})
      end

      it "should successfully login a user when given a valid cookie" do
        sign_in @user_goog
        User.stub(:find).and_return(@user_goog)
        get :verify
        response.body.should have_content("true")
      end

      it "should return a failure if the id is invalid" do
        User.stub(:find).and_return(nil)
        get :verify
        response.body.should have_content("false")
      end

    end

    it "should successfully respond if the user is already logged in" do
      sign_in @user_goog
      cookies.stub(:signed).and_return({user_c: @user_goog.id})
      get :verify
      response.body.should have_content("true")
    end

  end

end
