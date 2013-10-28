require 'spec_helper'

describe User do
  
  describe "Facebook find for" do

    before :each do
      @user = double(User)
      @info = double(User)
      @user.stub(:name).and_return("Jane Doe")
      @user.stub(:provider).and_return("google_oauth2")
      @user.stub(:info).and_return(@info)
      @user.stub(:uid).and_return("1234")
      @info.stub(:email).and_return("heyo")
    end 

    it "should successfully return a user" do
      User.stub(:where).and_return([@user])
      result = User.find_for_facebook_oauth(@user)
      expect(result).to be == @user
    end

    it "should successfully return a registered user" do
      User.stub(:where).and_return([], [@user])
      result = User.find_for_facebook_oauth(@user)
      expect(result).to be == @user
    end

  end

  describe "Google find for" do
    before :each do
      @user = double(User)
      @info = double(User)
      @user.stub(:name).and_return("Jane Doe")
      @user.stub(:provider).and_return("google_oauth2")
      @user.stub(:info).and_return(@info)
      @user.stub(:uid).and_return("1234")
      @info.stub(:email).and_return("heyo")
    end

    it "should successfully return a user" do
      User.stub(:where).and_return([@user])
      result = User.find_for_google_oauth2(@user)
      expect(result).to be == @user
    end

    it "should successfully return a registered user" do
      User.stub(:where).and_return([], [@user])
      result = User.find_for_google_oauth2(@user)
      expect(result).to be == @user
    end

  end


end
