Feature: create a current event pertaining to a social or political issue
	
	As a politically active citizen
	So that I can spread awareness about the issues I care about
	I want to be able to create current events that others can read about.

Scenario: create a barebones event
	
	Given I am on the home page	
	When I follow "Add Event"
	Then I should be on the new event page
	When I fill in "Title" with "Bart Strike"
	When I fill in "Datetime" with "10/18/2013"
	When I fill in "Location" with "Bay Area"
	When I fill in "Description" with "Bart Strike"
	And I press "Create Event"
	Then I should be on the home page
	And I should see "Bart Strike"