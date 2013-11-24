require 'spec_helper'

describe Issue do
	before :each do 
		@issue = Issue.new(description: "Some words", title: "Fake title")
	end
	it "should have a description and title" do
		@issue.should be_an_instance_of Issue
	end
	it "should have a valid description" do
		@issue.description.should eq"Some words"
	end
	it "should have a valid title" do 
		@issue.title.should eq "Fake title"
	end

end
