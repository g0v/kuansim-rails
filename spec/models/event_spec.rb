require 'spec_helper'

describe Event do
  	before :each do 
		@event = Event.new(datetime: "May 14, 2014", description: "Some words", location: "San Jose, CA", title: "Fake title", issue_id: "123")
	end
	it "should have a datetime, description, title" do
		@event.should be_an_instance_of Event
	end
	it "should have a valid description" do
		@event.description.should eq"Some words"
	end
	it "should have a valid title" do 
		@event.title.should eq "Fake title"
	end
end
