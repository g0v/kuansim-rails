require 'spec_helper'

describe Issue do
	before :each do 
		@issue = Issue.new(datetime: "May 14, 2014", description: "Some words", title: "Fake title")
	end
	it "should have a datetime, description, title" do
		@issue.should be_an_instance_of Issue
	end
	it "should have a valid description" do
		@issue.description.should eq"Some words"
	end
	it "should have a valid title" do 
		@issue.title.should eq "Fake title"
	end

end
