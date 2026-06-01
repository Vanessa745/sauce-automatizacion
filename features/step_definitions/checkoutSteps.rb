def click_css(selector)
  element = find(selector, visible: true)
  page.execute_script('arguments[0].scrollIntoView({block: "center"});', element)
  element.click
end

When('I proceed to checkout') do
  click_css('#checkout')
  expect(page).to have_current_path('/checkout-step-one.html', wait: 5)
end

Then('I should see the checkout information page') do
  expect(page).to have_current_path('/checkout-step-one.html', wait: 5)
  expect(page).to have_css('.title', text: 'Checkout: Your Information')
  expect(page).to have_css('#first-name')
  expect(page).to have_css('#last-name')
  expect(page).to have_css('#postal-code')
end

When('I enter checkout information with first name {string}, last name {string}, and postal code {string}') do |first_name, last_name, postal_code|
  find('#first-name', visible: true).set('')
  find('#last-name', visible: true).set('')
  find('#postal-code', visible: true).set('')

  find('#first-name', visible: true).set(first_name)
  find('#last-name', visible: true).set(last_name)
  find('#postal-code', visible: true).set(postal_code)
end

When('I continue the checkout process') do
  click_css('#continue')
end

When('I finish the checkout') do
  expect(page).to have_current_path('/checkout-step-two.html', wait: 5)
  click_css('#finish')
  expect(page).to have_current_path('/checkout-complete.html', wait: 5)
end

Then('I should see the checkout complete page') do
  expect(page).to have_current_path('/checkout-complete.html', wait: 5)
  expect(page).to have_css('.title', text: 'Checkout: Complete!')
end

Then('I should see the order confirmation message') do
  expect(page).to have_css('.complete-header', text: 'Thank you for your order!')
  expect(page).to have_css('.complete-text', text: 'Your order has been dispatched')
end

Then('I should see the product {string} in the checkout overview') do |product_name|
  expect(page).to have_current_path('/checkout-step-two.html', wait: 5)
  expect(page).to have_xpath("//div[contains(@class,'cart_item')]//div[contains(@class,'inventory_item_name') and normalize-space()='#{product_name}']")
end

Then('I should see a checkout error message {string}') do |expected_message|
  expect(page).to have_current_path('/checkout-step-one.html', wait: 5)
  expect(page).to have_css('[data-test="error"]', text: expected_message, wait: 5)
end

When('I cancel the checkout from the information page') do
  expect(page).to have_current_path('/checkout-step-one.html', wait: 5)
  click_css('#cancel')
end

Then('I should return to the cart page') do
  expect(page).to have_current_path('/cart.html', wait: 5)
  expect(page).to have_css('.title', text: 'Your Cart')
end

When('I cancel the checkout from the overview page') do
  expect(page).to have_current_path('/checkout-step-two.html', wait: 5)
  click_css('#cancel')
end

Then('I should return to the products page') do
  expect(page).to have_current_path('/inventory.html', wait: 5)
  expect(page).to have_css('.title', text: 'Products')
  expect(page).to have_css('.inventory_list')
  expect(page).to have_css('.inventory_item', minimum: 1)
end