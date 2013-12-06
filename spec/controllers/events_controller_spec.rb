require 'spec_helper'
require 'events_controller'
require 'json'

describe EventsController do
  before :each do
    @fake_data = {"event" => {
                    "title" => 'Bart Strike',
                    "location" => 'San Francisco, CA',
                    "description" => "This is a horrible event!",
                    "date_happened" => '1234567'}}
    @user = FactoryGirl.create(:user)
    sign_in @user
    @user_goog = FactoryGirl.create(:user_google)
    @event = FactoryGirl.create(:event)
  end

  describe 'create' do
    it 'creates a bookmark from bookmarklet request' do
      sign_out @user
      sign_in @user_goog
      @request.env["devise.mapping"] = Devise.mappings[:user]
      cookies.stub(:signed).and_return({:user_c => 300})
      User.stub(:find).and_return(@user_goog)
      post :create, @fake_data
      response.should be_success
    end

    it 'should create a new event' do
      post :create, @fake_data
      response.body.should have_content "true"
    end

  end
  describe 'delete' do
    it 'should delete the selected event' do
      @user.events = [@event]
      Event.stub(:find) {@event}
      delete :delete, {:id => @event.id}
      response.body.should have_content "true"
    end

    it 'should not delete the selected event if the user does not own the event' do
      Event.stub(:find) {@event}
      delete :delete, {:id => @event.id}
      response.body.should have_content "false"
    end
  end
  describe 'update' do

    it 'should update the selected event even if given no issues' do
      @fake_data["id"] = @event.id
      @user.events = [@event]
      Event.stub(:find) {@event}
      put :update, @fake_data
    end

    it 'should update the selected event if given a list of issues' do
      @fake_data["id"] = @event.id
      @user.events = [@event]
      @fake_data["issues"] = [FactoryGirl.create(:issue)]
      Event.stub(:find) {@event}
      put :update, @fake_data
    end

    it 'should not update a new event if the event does not exist' do
      Event.stub(:find) {@event}
      @event.should_not_receive(:update_attributes)
      @fake_data["id"] = 234
      put :update, @fake_data
    end
  end

  describe 'get_events' do
    it 'should get a list of all events' do
      Event.should_receive(:all)
      get :get_events
    end

    it 'should not get a list of events if the limit param is not an integer' do
      get :get_events, {:limit => "not an integer"}
      response.body.should have_content "[]"
    end

    it 'should get a list with a limited number of events' do
      Event.should_receive(:limit).with("5")
      get :get_events, {:limit => 5}
    end

  end

  describe "Bookmarklet view render" do
    before :each do
      @user_face = FactoryGirl.create(:user_facebook)
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    it "renders the bookmarklet view without login" do
      get :add_to_bookmark_btn
      response.should render_template("add_to_bookmark_btn")
    end
    it "renders the bookmarklet view because cannot find user" do
      request.cookies[:user_c] = '12345'
      cookies.stub(:signed).and_return({:user_c => 300})
      User.stub(:find).and_return(nil)
      get :add_to_bookmark_btn
      response.should render_template("add_to_bookmark_btn")
    end
    it "renders the bookmarklet view after login with match" do
      User.stub(:find).and_return(@user_goog)
      request.cookies[:user_c] = '12345'
      cookies.stub(:signed).and_return({:user_c => @user_goog.id})
      get :add_to_bookmark_btn
      response.should render_template("add_to_bookmark_btn")
    end
    it "renders the bookmarklet view if cookie is set" do
      sign_in @user_goog
      cookies.stub(:signed).and_return({:user_c => @user_goog.id})
      get :add_to_bookmark_btn
      response.should render_template("add_to_bookmark_btn")
    end
  end
end
