require 'spec_helper'
require 'events_controller'
require 'json'

describe EventsController do
  describe 'create' do
    it 'should create a new event' do
      user = FactoryGirl.create(:user)
      # user.confirm!
      sign_in user
      fake_data = {"event" => {
                      "title" => 'Bart Strike',
                      "location" => 'San Francisco, CA',
                      "description" => "This is a horrible event!",
                      "date_happened" => '1234567'}}
      fake_mod_data = {"title" => 'Bart Strike',
                       "location" => 'San Francisco, CA',
                       "description" => "This is a horrible event!",
                       "date_happened" => DateTime.parse(Time.at(1234567.0 / 1000.0).to_s),
                       "user_id" => user.id}
      # puts DateTime.parse(Time.at(1234567.0 / 1000.0).to_s)
      # puts DateTime.parse(Time.at(1234567.to_f / 1000.0).to_s)
      Event.should_receive(:create).with(fake_mod_data)
      post :create, fake_data
      puts response.body
    end
    it 'should not create a new event if no params are supplied' do
      Event.should_not_receive(:create)
      post :create
    end
  end
  describe 'delete' do
    it 'should delete the selected event' do
      user = FactoryGirl.create(:user)
      # user.confirm!
      sign_in user
      Event.should_receive(:find).with(user.events[0].id)
      Event.should_receive(:delete).with(user.events[0].id)
      post :delete, {:id => user.events[0].id}
      puts response.body
    end
    it 'should not delete the selected event if the user does not own the event' do
    end
  end
  describe 'get_events' do
    it 'should get a list of all events' do
      Event.should_receive(:all)
      get :get_events
    end
  end
end
