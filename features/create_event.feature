Feature: create a current event pertaining to a social or political issue
	
	As a politically active citizen
	So that I can spread awareness about the issues I care about
	I want to be able to create current events that others can read about.

Scenario: create a barebones event
	
	When I click on the "create_event" link
	When I input the title as "Bart Strike", the date as "10/18/2013", the location as "Bay Area", the description as "Bart strike."
	And I click on the "submit_new_event" link
	Then I should see the event timeline of the event "Bart Strike"