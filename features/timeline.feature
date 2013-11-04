Feature: Timeline view of related events with the same tag

	 As a politically active citizen
	 So that I can get a better sense of all the issues
	 I want to be able to see the events in a timeline view

Scenario: show timeline when you click on an event
	  
	  Given I am on the home page
	  When I follow the title "Bart Strike"
	  Then I should see "timeline"
	  Then I should see "Oct 22, 2013" 
	  Then I should see "BART Unions Ratify Contract That Ended Strike"
	  Then I should see "BART Walkout Over"

Scenario: show timeline when you click on a tag
	  
	  Given I am on the home page
	  When I follow the tag "transportation"
	  Then I should see "timeline"
	  Then I should see "Bart Strike"