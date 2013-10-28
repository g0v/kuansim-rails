Feature: login to kuansim using a third party's signle-sign-on

	As an politically and socially active citizen
	So that I can stay connected with others who care about the same issues
	I want to be connected through Facebook or Google

@omniauth_test
Scenario: login via Facebook
	Given I am on the home page
	When I follow "Login"
	When I follow "Sign in with Facebook"
	Then I should be on the home page

@omniauth_test
Scenario: login via Google
	Given I am on the home page
	When I follow "Login"
	When I follow "Sign in with Google"
	Then I should be on the home page