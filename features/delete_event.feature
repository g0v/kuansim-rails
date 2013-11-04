Feature: delete a current event pertaining to a social or political issue
	
	As a politically active citizen
	So that I efficiently organize the events I create
	I want to be able to delete events I've created.

Scenario: delete an existing event
	
	Given I am on the home page
	When I follow Timeline
	Then I should be on the timeline page
	When I follow "Bart Strike"
	When I am the author of "Bart Strike"
	Then I should see "delete"
