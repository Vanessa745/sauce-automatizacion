Feature: Add products to the shopping cart
  As a logged-in SauceDemo user
  I want to add products to my shopping cart
  So that I can prepare the items I want to buy

  Background:
    Given I am logged in to SauceDemo
    And I am on the products page

  Scenario: Add one product to the cart
    When I add the product "Sauce Labs Backpack" to the cart
    Then the cart badge should show "1"
    And the "Sauce Labs Backpack" button should change to "Remove"

  Scenario: Add two different products to the cart
    When I add the product "Sauce Labs Backpack" to the cart
    And I add the product "Sauce Labs Bike Light" to the cart
    Then the cart badge should show "2"
    And the "Sauce Labs Backpack" button should change to "Remove"
    And the "Sauce Labs Bike Light" button should change to "Remove"

  Scenario: Add a product and verify it appears in the cart page
    When I add the product "Sauce Labs Backpack" to the cart
    And I open the shopping cart
    Then I should see the product "Sauce Labs Backpack" in the cart

  Scenario: Add multiple products and verify them in the cart page
    When I add the product "Sauce Labs Backpack" to the cart
    And I add the product "Sauce Labs Bolt T-Shirt" to the cart
    And I open the shopping cart
    Then I should see the product "Sauce Labs Backpack" in the cart
    And I should see the product "Sauce Labs Bolt T-Shirt" in the cart

  Scenario: Remove a product after adding it to the cart
    When I add the product "Sauce Labs Backpack" to the cart
    And I remove the product "Sauce Labs Backpack" from the products page
    Then the cart badge should not be visible
    And the "Sauce Labs Backpack" button should change to "Add to cart"

  Scenario: Remove one product when two products were added
    When I add the product "Sauce Labs Backpack" to the cart
    And I add the product "Sauce Labs Bike Light" to the cart
    And I remove the product "Sauce Labs Backpack" from the products page
    Then the cart badge should show "1"
    And the "Sauce Labs Backpack" button should change to "Add to cart"
    And the "Sauce Labs Bike Light" button should change to "Remove"