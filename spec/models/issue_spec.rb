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

  describe "related issues" do

    before :each do
    	@bart = FactoryGirl.create(:bart_strike_issue)
    	@bart_event = FactoryGirl.create(:bart_event)
    	@malaysia = FactoryGirl.create(:malaysia_strike_issue)
    	@malaysia_event = FactoryGirl.create(:malaysia_event)
      [@bart_event, @malaysia_event].each do |event|
        event.issues << @bart
        event.issues << @malaysia
      end
      @drinking = FactoryGirl.create(:drinking_issue)
      @drinking_event = FactoryGirl.create(:freshmen_drink)
      @drink_event.issues << @drinking
      [@bart_event, @drink_event, @malaysia_event].each {|event| event.save }
    end

    it "should be successfully found and displayed" do
      @bart.related_issues.should_return [@malaysia]
    end

    it "should not display issues that have 0 events in common" do
      @drinking.related_issues.should_return []
    end

  end
end
