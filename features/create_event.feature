Feature: create a current event pertaining to a social or political issue
	
	As a politically active citizen
	So that I can spread awareness about the issues I care about
	I want to be able to create current events that others can read about.

Scenario: create a barebones event
	
	When I follow "add_event"
	Then I should be on the "new_event" page
	When I fill in "title" with "Bart Strike"
	When I fill in "date" with "10/18/2013"
	When I fill in "location" with "Bay Area"
	When I fill in "description" with "Bart Strike"
	And I press "submit_new_event"
	Then I should be on the home page
	and I should see "Bart Strike"