require 'spec_helper'

describe HomeController do
	describe 'index' do
		it 'should show all the events' do
			Event.should_receive(:all)
			get :index
		end
	end
end
