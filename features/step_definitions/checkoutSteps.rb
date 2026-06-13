# features/step_definitions/checkoutSteps.rb

When('I proceed to checkout') do
  @cart_page ||= CartPage.new
  @cart_page.validate_cart_page
  @cart_page.proceed_to_checkout

  @checkout_information_page = CheckoutInformationPage.new
  @checkout_information_page.validate_page
end

Then('I should see the checkout information form') do
  @checkout_information_page ||= CheckoutInformationPage.new
  @checkout_information_page.validate_page
end

Then('I should see fields for first name, last name, and postal code') do
  @checkout_information_page ||= CheckoutInformationPage.new
  @checkout_information_page.validate_required_fields
end

When('I enter checkout information with first name {string}, last name {string}, and postal code {string}') do |first_name, last_name, postal_code|
  @checkout_information_page ||= CheckoutInformationPage.new
  @checkout_information_page.fill_information(first_name, last_name, postal_code)
end

When('I continue the checkout process') do
  @checkout_information_page ||= CheckoutInformationPage.new
  @checkout_information_page.continue_checkout

  if page.has_current_path?('/checkout-step-two.html', wait: 2)
    @checkout_overview_page = CheckoutOverviewPage.new
    @checkout_overview_page.validate_page
  end
end

Then('I should see the product {string} in the checkout overview') do |product_name|
  @checkout_overview_page ||= CheckoutOverviewPage.new
  @checkout_overview_page.validate_product(product_name)
end

When('I finish the checkout') do
  @checkout_overview_page ||= CheckoutOverviewPage.new
  @checkout_overview_page.finish_checkout

  @checkout_complete_page = CheckoutCompletePage.new
  @checkout_complete_page.validate_page
end

Then('I should see the checkout completion title {string}') do |expected_title|
  @checkout_complete_page ||= CheckoutCompletePage.new
  @checkout_complete_page.validate_completion_title(expected_title)
end

Then('I should see the order confirmation message {string}') do |expected_message|
  @checkout_complete_page ||= CheckoutCompletePage.new
  @checkout_complete_page.validate_order_confirmation_message(expected_message)
end

Then('I should see the dispatch message {string}') do |expected_message|
  @checkout_complete_page ||= CheckoutCompletePage.new
  @checkout_complete_page.validate_dispatch_message(expected_message)
end

Then('I should remain on the checkout information form') do
  @checkout_information_page ||= CheckoutInformationPage.new
  @checkout_information_page.validate_user_remains_on_form
end

Then('I should see a checkout error message {string}') do |expected_message|
  @checkout_information_page ||= CheckoutInformationPage.new
  @checkout_information_page.validate_error_message(expected_message)
end

When('I cancel the checkout from the information page') do
  @checkout_information_page ||= CheckoutInformationPage.new
  @checkout_information_page.cancel_checkout

  @cart_page = CartPage.new
  @cart_page.validate_cart_page
end

Then('I should return to the cart page') do
  @cart_page ||= CartPage.new
  @cart_page.validate_cart_page
end

Then('I should still see the product {string} in the cart') do |product_name|
  @cart_page ||= CartPage.new
  @cart_page.validate_product_in_cart(product_name)
end

When('I cancel the checkout from the overview page') do
  @checkout_overview_page ||= CheckoutOverviewPage.new
  @checkout_overview_page.cancel_checkout

  @catalog_page = CatalogPage.new
  @catalog_page.validate_products_page
end

Then('I should return to the products page') do
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_products_page
end

Then('I should see the product catalog') do
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_product_catalog
end

Then('I should see the item total {string}') do |expected_item_total|
  @checkout_overview_page ||= CheckoutOverviewPage.new
  @checkout_overview_page.validate_item_total(expected_item_total)
end

Then('I should see the tax amount {string}') do |expected_tax|
  @checkout_overview_page ||= CheckoutOverviewPage.new
  @checkout_overview_page.validate_tax(expected_tax)
end

Then('I should see the final total {string}') do |expected_total|
  @checkout_overview_page ||= CheckoutOverviewPage.new
  @checkout_overview_page.validate_final_total(expected_total)
end

Then('the checkout total should match the visible product prices') do
  @checkout_overview_page ||= CheckoutOverviewPage.new
  @checkout_overview_page.validate_total_matches_visible_product_prices
end