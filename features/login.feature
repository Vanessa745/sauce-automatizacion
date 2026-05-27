Feature: Login to SauceDemo
  As a registered SauceDemo user
  I want to log in with my credentials
  So that I can access the product inventory

  Background:
    Given I am on the SauceDemo login page

  Scenario: Successful login with valid credentials
    When I enter the username "standard_user"
    And I enter the password "secret_sauce"
    And I click the login button
    Then I should see the products page

  Scenario: Failed login with an incorrect password
    When I enter the username "standard_user"
    And I enter the password "wrong_password"
    And I click the login button
    Then I should see "Epic sadface: Username and password do not match any user in this service" error message

  Scenario: Failed login with a locked out user
    When I enter the username "locked_out_user"
    And I enter the password "secret_sauce"
    And I click the login button
    Then I should see "Epic sadface: Sorry, this user has been locked out." error message

  Scenario: Failed login without credentials
    When I click the login button
    Then I should see "Epic sadface: Username is required" error message