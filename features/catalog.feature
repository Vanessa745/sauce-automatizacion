Feature: Sort products in SauceDemo
  As a logged-in SauceDemo user
  I want to sort the product catalog
  So that I can compare products more easily

  Background:
    Given I am logged in to SauceDemo as "standard_user"
    And I am on the products page

  Scenario Outline: Sort products by name
    When I select the sort option "<sort_option>"
    Then the first product displayed should be "<first_product>"
    And the products should be displayed by name "<expected_order>"

    Examples:
      | sort_option   | first_product                     | expected_order |
      | Name (A to Z) | Sauce Labs Backpack               | from A to Z    |
      | Name (Z to A) | Test.allTheThings() T-Shirt (Red) | from Z to A    |

  Scenario Outline: Sort products by price
    When I select the sort option "<sort_option>"
    Then the first product displayed should be "<first_product>"
    And the first product price should be "<first_price>"
    And the products should be displayed by price "<expected_order>"

    Examples:
      | sort_option         | first_product             | first_price | expected_order         |
      | Price (low to high) | Sauce Labs Onesie         | $7.99       | from lowest to highest |
      | Price (high to low) | Sauce Labs Fleece Jacket  | $49.99      | from highest to lowest |  