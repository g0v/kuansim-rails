require 'spec_helper'

describe UsersController do

  before :each do
    @user_goog = User.create(
      name: "John Doe",
      provider: "google",
      uid: "1234",
      email: "dont@mail.me",
      password: "zzzz"
      )
    @user_face = User.create(
      name: "Jane Doe",
      provider: "facebook",
      uid: "999",
      email: "mail@mail.me",
      password: "aaaaa"
      )
  end

  it "should successfully render json info of a valid google user" do
    uri = double(URI)
    uri.stub(:read).and_return({good: 'stuff', hey: 'yo'})
    URI.stub(:parse).and_return(uri)
    JSON.stub(:parse).and_return(@user_goog.as_json)
    User.stub(:find_by_provider).and_return(@user_goog)

    post :authenticate, provider: "google", access: "ehgalhdglskahg3"
    assigns(:user).should == @user_goog
    response.should be_success
  end

  it "should successfully render json info of a valid facebook user" do
    uri = double(URI)
    uri.stub(:read).and_return({good: 'stuff', hey: 'yo'})
    URI.stub(:parse).and_return(uri)
    JSON.stub(:parse).and_return(@user_face.as_json)
    User.stub(:find_by_provider).and_return(@user_face)

    post :authenticate, provider: "facebook", access: "ehgalhdglskahg3"
    assigns(:user).should == @user_face
    response.should be_success
  end

  it "should successfully log out a user" do
    sign_in @user_goog
    post :destroy_session, email: @user_goog.email
    response.should be_success
  end

end
