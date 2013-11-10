require 'spec_helper'
require 'events_controller'
require 'json'

describe EventsController do
  describe 'create' do
    it 'should create a new event' do
      fake_data = {"title" => 'Bart Strike',
                   "date_happened" => '1234567',
                   "location" => 'San Francisco, CA',
                   "description" => "This is a horrible event!"}
      fake_mod_data = {"title" => 'Bart Strike',
                       "location" => 'San Francisco, CA',
                       "description" => "This is a horrible event!",
                       "date_happened" => DateTime.parse(Time.at(1234567 / 1000).to_s)}
      Event.should_receive(:create).with(fake_mod_data)
      post :create, {:event => fake_data}
    end
    it 'should not create a new event if no params are supplied' do
      Event.should_not_receive(:create)
      post :create
    end
  end
  describe 'delete' do
    it 'should delete the selected event' do
      fake_id = "1"
      Event.should_receive(:delete).with(fake_id.to_i)
      post :delete, {:id => fake_id}
    end
    it 'should not delete the selected event if the user does not own the event' do
      mock('user')
    end
  end
  describe 'get_events' do
    it 'should get a list of all events' do
      Event.should_receive(:all)
      get :get_events
    end
  end
end
