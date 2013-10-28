require 'spec_helper'
require 'events_controller'

describe EventsController do
	describe 'create' do
		it 'should create a new event' do
			fake_data = {"title" => 'Bart Strike',
						 "datetime" => '10/18/2013',
						 "location" => 'San Francisco, CA',
						 "description" => "This is a horrible event!"}
			Event.should_receive(:create).with(fake_data)
			post :create, {:event => fake_data}
		end
	end
end
