Feature: Sort products in SauceDemo
  As a logged-in SauceDemo user
  I want to sort the product inventory
  So that I can view products in the order that best helps me compare them

  Background:
    Given I am logged in to SauceDemo as "standard_user"
    And I am on the products page

  Scenario Outline: Sort products by name
    When I sort the products by "<sort_option>"
    Then the products should be displayed by name in "<order>" order

    Examples:
      | sort_option   | order      |
      | Name (A to Z) | ascending  |
      | Name (Z to A) | descending |

  Scenario Outline: Sort products by price
    When I sort the products by "<sort_option>"
    Then the products should be displayed by price in "<order>" order

    Examples:
      | sort_option          | order      |
      | Price (low to high)  | ascending  |
      | Price (high to low)  | descending |