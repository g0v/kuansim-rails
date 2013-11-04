Feature: logout from kuansim using a third party's signle-sign-on

	As an politically and socially active citizen
	So that I can stay connected with others who care about the same issues
	I want to be connected through Facebook or Google
	And log out for security reasons

@omniauth_test
Scenario: logout via Facebook
	Given I am on the home page
	When I am logged in
	When I follow "Logout"
	Then I should be on the home page
	Then I should see "Login"

@omniauth_test
Scenario: logout via Google
	Given I am on the home page
	When I am logged in
	When I follow "Logout"
	Then I should be on the home page
	Then I should see "Login"