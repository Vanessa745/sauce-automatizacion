Feature: Checkout products in SauceDemo
  As a logged-in SauceDemo user
  I want to complete the checkout process
  So that I can finish purchasing the products in my cart

  Background:
    Given I am logged in to SauceDemo as "standard_user"
    And I am on the products page

  Scenario: Start checkout with one product in the cart
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    Then I should see the checkout information page

  Scenario: Complete checkout with one product
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "Canaviri", and postal code "0000"
    And I continue the checkout process
    And I finish the checkout
    Then I should see the checkout complete page
    And I should see the order confirmation message

  Scenario: Complete checkout with multiple products
    When I add the product "Sauce Labs Backpack" to the cart
    And I add the product "Sauce Labs Bike Light" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "QA", and postal code "0000"
    And I continue the checkout process
    Then I should see the product "Sauce Labs Backpack" in the checkout overview
    And I should see the product "Sauce Labs Bike Light" in the checkout overview
    When I finish the checkout
    Then I should see the checkout complete page
    And I should see the order confirmation message

  Scenario: Checkout fails when first name is missing
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "", last name "Canaviri", and postal code "0000"
    And I continue the checkout process
    Then I should see a checkout error message "Error: First Name is required"

  Scenario: Checkout fails when last name is missing
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "", and postal code "0000"
    And I continue the checkout process
    Then I should see a checkout error message "Error: Last Name is required"

  Scenario: Checkout fails when postal code is missing
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "Canaviri", and postal code ""
    And I continue the checkout process
    Then I should see a checkout error message "Error: Postal Code is required"

  Scenario: Cancel checkout from checkout information page
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I cancel the checkout from the information page
    Then I should return to the cart page

  Scenario: Cancel checkout from checkout overview page
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "Canaviri", and postal code "0000"
    And I continue the checkout process
    And I cancel the checkout from the overview page
    Then I should return to the products page