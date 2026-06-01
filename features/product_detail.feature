Feature: Product detail consistency in SauceDemo
  As a logged-in SauceDemo user
  I want product details to match the catalog information
  So that I can trust the product information before buying

  Background:
    Given I am logged in to SauceDemo as "standard_user"
    And I am on the products page

  Scenario Outline: Verify product information consistency between catalog and detail page
    When I save the catalog information for product "<product_name>"
    And I open the detail page for product "<product_name>"
    Then the product detail information should match the catalog information
    And I return to the products page

    Examples:
      | product_name            |
      | Sauce Labs Backpack     |
      | Sauce Labs Bike Light   |
      | Sauce Labs Bolt T-Shirt |