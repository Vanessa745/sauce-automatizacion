Given('I am logged in to SauceDemo as {string}') do |username|
  visit('https://www.saucedemo.com/')

  fill_in('user-name', with: username)
  fill_in('password', with: 'secret_sauce')
  click_button('login-button')

  expect(page).to have_current_path('/inventory.html')
end

Given('I am on the products page') do
  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_content('Products')
end

When('I add the product {string} to the cart') do |product_name|
  product = find('.inventory_item', text: product_name)

  within(product) do
    click_button('Add to cart')
  end
end

When('I remove the product {string} from the products page') do |product_name|
  product = find('.inventory_item', text: product_name)

  within(product) do
    click_button('Remove')
  end
end

When('I open the shopping cart') do
  find('.shopping_cart_link').click
end

Then('the cart badge should show {string}') do |expected_quantity|
  expect(page).to have_css('.shopping_cart_badge', text: expected_quantity)
end

Then('the cart badge should not be visible') do
  expect(page).to have_no_css('.shopping_cart_badge')
end

Then('the Add to cart button for the {string} product should change to {string}') do |product_name, expected_button_text|
  product = find('.inventory_item', text: product_name)

  within(product) do
    expect(page).to have_button(expected_button_text)
  end
end

Then('the Remove button for the {string} product should change to {string}') do |product_name, expected_button_text|
  product = find('.inventory_item', text: product_name)

  within(product) do
    expect(page).to have_button(expected_button_text)
  end
end

Then('I should see the product {string} in the cart') do |product_name|
  expect(page).to have_current_path('/cart.html')
  expect(page).to have_css('.cart_item', text: product_name)
end