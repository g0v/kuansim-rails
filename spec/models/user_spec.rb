require 'spec_helper'

describe User do

  describe "Find with invalid provider" do
    it "should raise exception" do 
      expect{User.find_by_provider("twitter", "user")}.to raise_error("Invalid provider")
    end
  end

  describe "Get user when user exists already" do
    before :each do
      @user = double(User)
      @info = double(User)
      @user.stub(:name).and_return("Jane Doe")
      @user.stub(:provider).and_return("google_oauth2")
      @user.stub(:info).and_return(@info)
      @user.stub(:uid).and_return("1234")
      @info.stub(:email).and_return("heyo")
    end 
    it "should return user" do 
    end
    it "should return registered user" do 
    end
  end
  describe "Create new user" do 
    before :each do
      @user_info = {"email"=>"ms@goog.com", "name"=>"robot", "id"=>"123"}
    end
    it "should create a new user" do 
      @user = User.find_by_provider(@user_info, "google")
      expect(User.where(provider: "google", uid: @user_info[:id])).to be_true
    end
  end
end
