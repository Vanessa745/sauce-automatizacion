Feature: Login to SauceDemo
  As a registered SauceDemo user
  I want to log in with my credentials
  So that I can access the product inventory

  Background:
    Given I am on the SauceDemo login page

  Scenario Outline: Login with multiple credential combinations
    When I enter the username "<username>"
    And I enter the password "<password>"
    And I click the login button
    Then I should see the login result "<result>" with message "<message>"

    Examples:
      | username                 | password       | result  | message                                                                   |
      | standard_user            | secret_sauce   | success | Products                                                                  |
      | problem_user             | secret_sauce   | success | Products                                                                  |
      | performance_glitch_user  | secret_sauce   | success | Products                                                                  |
      | visual_user              | secret_sauce   | success | Products                                                                  |
      | error_user               | secret_sauce   | success | Products                                                                  |
      | locked_out_user          | secret_sauce   | error   | Epic sadface: Sorry, this user has been locked out.                       |
      | standard_user            | wrong_password | error   | Epic sadface: Username and password do not match any user in this service |
      |                          | secret_sauce   | error   | Epic sadface: Username is required                                        |
      | standard_user            |                | error   | Epic sadface: Password is required                                        |