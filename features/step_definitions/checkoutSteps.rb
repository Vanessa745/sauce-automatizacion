Given('I am logged in to SauceDemo as {string}') do |username|
  visit('https://www.saucedemo.com/')

  fill_in('user-name', with: username)
  fill_in('password', with: 'secret_sauce')
  click_button('login-button')

  expect(page).to have_current_path('/inventory.html')
end

When('I proceed to checkout') do
  click_button('Checkout')
end

Then('I should see the checkout information page') do
  expect(page).to have_current_path('/checkout-step-one.html')
  expect(page).to have_content('Checkout: Your Information')
end

When('I enter checkout information with first name {string}, last name {string}, and postal code {string}') do |first_name, last_name, postal_code|
  fill_in('first-name', with: first_name)
  fill_in('last-name', with: last_name)
  fill_in('postal-code', with: postal_code)
end

When('I continue the checkout process') do
  click_button('Continue')
end

When('I finish the checkout') do
  click_button('Finish')
end

Then('I should see the checkout complete page') do
  expect(page).to have_current_path('/checkout-complete.html')
  expect(page).to have_content('Checkout: Complete!')
end

Then('I should see the order confirmation message') do
  expect(page).to have_content('Thank you for your order!')
  expect(page).to have_content('Your order has been dispatched')
end

Then('I should see the product {string} in the checkout overview') do |product_name|
  expect(page).to have_current_path('/checkout-step-two.html')
  expect(page).to have_css('.cart_item', text: product_name)
end

Then('I should see a checkout error message {string}') do |expected_message|
  expect(page).to have_css('[data-test="error"]', text: expected_message)
end

When('I cancel the checkout from the information page') do
  click_button('Cancel')
end

Then('I should return to the cart page') do
  expect(page).to have_current_path('/cart.html')
  expect(page).to have_content('Your Cart')
end

When('I cancel the checkout from the overview page') do
  click_button('Cancel')
end

Then('I should return to the products page') do
  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_content('Products')
end