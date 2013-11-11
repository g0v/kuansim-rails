require 'spec_helper'

describe Event do
  	before :each do 
		@event = Event.new(date_happened: "112233", description: "Some words", location: "San Jose, CA", title: "Fake title", issue_id: "123")
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
	it "should be able to be as json" do
		h = {"id" => "1", "title" => "ASDF", "date_happened" => "112233"} 
		expect{@event.as_json(h)}.to be_true
	end
end
