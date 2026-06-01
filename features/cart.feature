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
    And the Add to cart button for the "Sauce Labs Backpack" product should change to "Remove"

  Scenario: Add two different products to the cart
    When I add the product "Sauce Labs Bolt T-Shirt" to the cart
    And I add the product "Sauce Labs Fleece Jacket" to the cart
    Then the cart badge should show "2"
    And the Add to cart button for the "Sauce Labs Bolt T-Shirt" product should change to "Remove"
    And the Add to cart button for the "Sauce Labs Fleece Jacket" product should change to "Remove"

  Scenario: Add a product and verify it appears in the cart page
    When I add the product "Sauce Labs Bike Light" to the cart
    And I open the shopping cart
    Then I should see the product "Sauce Labs Bike Light" in the cart

  Scenario Outline: Add multiple products and verify them in the cart page
    When I add the product "Sauce Labs Onesie" to the cart
    And I add the product "Test.allTheThings() T-Shirt (Red)" to the cart
    And I open the shopping cart
    Then I should see the product "Sauce Labs Onesie" in the cart
    And I should see the product "Test.allTheThings() T-Shirt (Red)" in the cart

  Scenario Outline: Remove a product after adding it to the cart
    When I add the product "Sauce Labs Backpack" to the cart
    And I remove the product "Sauce Labs Backpack" from the products page
    Then the cart badge should not be visible
    And the Remove button for the "Sauce Labs Backpack" product should change to "Add to cart"

  Scenario Outline: Remove one product when two products were added
    When I add the product "Sauce Labs Onesie" to the cart
    And I add the product "Sauce Labs Fleece Jacket" to the cart
    And I remove the product "Sauce Labs Onesie" from the products page
    Then the cart badge should show "1"
    And the Remove button for the "Sauce Labs Onesie" product should change to "Add to cart"
    And the Add to cart button for the "Sauce Labs Fleece Jacket" product should change to "Remove"
