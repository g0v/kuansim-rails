require 'spec_helper'
require 'events_controller'
require 'json'

describe EventsController do
  describe 'create' do
    it 'should create a new event' do
      user = FactoryGirl.create(:user)
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
      Event.should_receive(:create).with(fake_mod_data)
      post :create, fake_data
    end
    it 'should not create a new event if no params are supplied' do
      Event.should_not_receive(:create)
      post :create
    end
    it 'should not create a new event if the user is not logged in' do
      fake_data = {"event" => {
                    "title" => 'Bart Strike',
                    "location" => 'San Francisco, CA',
                    "description" => "This is a horrible event!",
                    "date_happened" => '1234567'}}
      Event.should_not_receive(:create)
      post :create, fake_data
    end
  end
  describe 'delete' do
    it 'should delete the selected event' do
      event = FactoryGirl.create(:event)
      user = FactoryGirl.create(:user, events: [event])
      sign_in user
      Event.stub(:find) {event}
      Event.should_receive(:find).with(event.id)
      Event.should_receive(:delete).with(event.id)
      delete :delete, {:id => event.id}
    end
    it 'should not delete the selected event if the user is not logged in' do
      Event.should_not_receive(:delete)
      delete :delete, {:id => 1}
    end
    it 'should not delete the selected event if the user does not own the event' do
      event = FactoryGirl.create(:event)
      user = FactoryGirl.create(:user)
      sign_in user
      Event.stub(:find) {event}
      Event.should_receive(:find).with(event.id)
      Event.should_not_receive(:delete)
      delete :delete, {:id => event.id}
    end
  end
  describe 'update' do
    it 'should update the selected event' do
      user = FactoryGirl.create(:user)
      sign_in user
      event = FactoryGirl.create(:event)
      fake_data = { "id" => event.id,
                    "event" => {
                      "title" => 'Bart Strike',
                      "location" => 'San Francisco, CA',
                      "description" => "This is a horrible event!",
                      "date_happened" => '1234567'} }
      fake_mod_data = {"title" => 'Bart Strike',
                       "location" => 'San Francisco, CA',
                       "description" => "This is a horrible event!",
                       "date_happened" => DateTime.parse(Time.at(1234567.0 / 1000.0).to_s),
                       "user_id" => user.id}
      Event.stub(:find) {event}
      Event.should_receive(:find).with(event.id)
      event.should_receive(:update_attributes).with(fake_mod_data)
      put :update, fake_data
      puts response.body
    end
    it 'should not update a new event if the event does not exist' do
      event = FactoryGirl.create(:event)
      Event.stub(:find) {event}
      event.should_not_receive(:update_attributes)
      fake_data = { "id" => 3,
                    "event" => {
                      "title" => 'Bart Strike',
                      "location" => 'San Francisco, CA',
                      "description" => "This is a horrible event!",
                      "date_happened" => '1234567'} }
      put :update, fake_data
    end
  end
  describe 'get_events' do
    it 'should get a list of all events' do
      Event.should_receive(:all)
      get :get_events
    end
    it 'should not get a list of events if the limit param is not an integer' do
      Event.should_not_receive(:all)
      Event.should_not_receive(:take)
      get :get_events, {:limit => "not an integer"}
    end
    it 'should get a list with a limited number of events' do
      Event.should_receive(:take)
      Event.should_not_receive(:all)
      get :get_events, {:limit => 5}
    end
  end
end
