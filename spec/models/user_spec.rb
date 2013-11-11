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
      User.find_by_provider("some info", "google")
    end
    it "should return registered user" do 
    end
  end
end
