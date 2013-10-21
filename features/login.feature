Feature: login to kuansim using a third party's signle-sign-on

	As an politically and socially active citizen
	So that I can stay connected with others who care about the same issues
	I want to be connected through Facebook, Github, Google, or Twitter

Scenario: login via Facebook
	When I click on the "login" link
	When I choose to login via Facebook
	When I input "coolfred12345@gmail.com" and "secretpw12345"
	Then I should be authenticated successfully

Scenario: login via Github
	When I click on the "login" link
	When I choose to login via Github
	When I input "coolfred12345@gmail.com" and "secretpw12345"
	Then I should be authenticated successfully

Scenario: login via Google
	When I click on the "login" link
	When I choose to login via Google
	When I input "coolfred12345@gmail.com" and "secretpw12345"
	Then I should be authenticated successfully

Scenario: login via Twitter
	When I click on the "login" link
	When I choose to login via Twitter
	When I input "coolfred12345@gmail.com" and "secretpw12345"
	Then I should be authenticated successfully