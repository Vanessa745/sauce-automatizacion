Feature: Checkout products in SauceDemo
  As a logged-in SauceDemo user
  I want to complete the checkout process
  So that I can finish purchasing the products in my cart

  Background:
    Given I am logged in to SauceDemo as "standard_user"
    And I am on the products page

  @smoke
  Scenario: Start checkout with one product in the cart
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    Then I should see the checkout information form
    And I should see fields for first name, last name, and postal code

  @smoke
  Scenario: Complete checkout with one product
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "Canaviri", and postal code "0000"
    And I continue the checkout process
    Then I should see the product "Sauce Labs Backpack" in the checkout overview
    When I finish the checkout
    Then I should see the checkout completion title "Checkout: Complete!"
    And I should see the order confirmation message "Thank you for your order!"
    And I should see the dispatch message "Your order has been dispatched"

  @smoke
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
    Then I should see the checkout completion title "Checkout: Complete!"
    And I should see the order confirmation message "Thank you for your order!"
    And I should see the dispatch message "Your order has been dispatched"

  @smoke
  Scenario: Verify payment amount for one product
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "Canaviri", and postal code "0000"
    And I continue the checkout process
    Then I should see the product "Sauce Labs Backpack" in the checkout overview
    And I should see the item total "$29.99"
    And I should see the tax amount "$2.40"
    And I should see the final total "$32.39"
    And the checkout total should match the visible product prices

  @smoke
  Scenario: Verify payment amount for multiple products
    When I add the product "Sauce Labs Backpack" to the cart
    And I add the product "Sauce Labs Bike Light" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "Canaviri", and postal code "0000"
    And I continue the checkout process
    Then I should see the product "Sauce Labs Backpack" in the checkout overview
    And I should see the product "Sauce Labs Bike Light" in the checkout overview
    And I should see the item total "$39.98"
    And I should see the tax amount "$3.20"
    And I should see the final total "$43.18"
    And the checkout total should match the visible product prices

  @regression
  Scenario Outline: Checkout fails when required customer information is missing
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "<first_name>", last name "<last_name>", and postal code "<postal_code>"
    And I continue the checkout process
    Then I should remain on the checkout information form
    And I should see a checkout error message "<error_message>"

    Examples:
      | first_name | last_name | postal_code | error_message                  |
      |            | Canaviri  | 0000        | Error: First Name is required  |
      | Vanessa    |           | 0000        | Error: Last Name is required   |
      | Vanessa    | Canaviri  |             | Error: Postal Code is required |

  @regression
  Scenario: Cancel checkout from checkout information page
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I cancel the checkout from the information page
    Then I should return to the cart page
    And I should still see the product "Sauce Labs Backpack" in the cart

  @regression
  Scenario: Cancel checkout from checkout overview page
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    And I proceed to checkout
    And I enter checkout information with first name "Vanessa", last name "Canaviri", and postal code "0000"
    And I continue the checkout process
    And I cancel the checkout from the overview page
    Then I should return to the products page
    And I should see the product catalog