Given('I am logged in to SauceDemo as {string}') do |username|
  @login_page = LoginPage.new
  @login_page.open
  @login_page.enter_username(username)
  @login_page.enter_password('secret_sauce')
  @login_page.click_login_button
  @login_page.validate_successful_login('Products')

  @catalog_page = CatalogPage.new
end

Given('I am on the products page') do
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_products_page
end

When('I add the product {string} to the cart') do |product_name|
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_products_page
  @catalog_page.add_product_to_cart(product_name)
end

When('I remove the product {string} from the products page') do |product_name|
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_products_page
  @catalog_page.remove_product_from_products_page(product_name)
end

When('I open the shopping cart') do
  @catalog_page ||= CatalogPage.new
  @catalog_page.open_shopping_cart

  @cart_page = CartPage.new
  @cart_page.validate_cart_page
end

Then('the cart badge should show {string}') do |expected_quantity|
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_cart_badge(expected_quantity)
end

Then('the cart badge should not be visible') do
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_cart_badge_not_visible
end

Then('the Add to cart button for the {string} product should change to {string}') do |product_name, expected_button_text|
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_products_page
  @catalog_page.validate_product_button_text(product_name, expected_button_text)
end

Then('the Remove button for the {string} product should change to {string}') do |product_name, expected_button_text|
  @catalog_page ||= CatalogPage.new
  @catalog_page.validate_products_page
  @catalog_page.validate_product_button_text(product_name, expected_button_text)
end

Then('I should see the product {string} in the cart') do |product_name|
  @cart_page ||= CartPage.new
  @cart_page.validate_product_in_cart(product_name)
end