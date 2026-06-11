# features/step_definitions/checkoutSteps.rb

def click_css(selector)
  element = find(selector, visible: true)
  page.execute_script('arguments[0].scrollIntoView({block: "center"});', element)
  element.click
end

def checkout_information_fields
  {
    first_name: find('#first-name', visible: true),
    last_name: find('#last-name', visible: true),
    postal_code: find('#postal-code', visible: true)
  }
end

def clear_checkout_information_fields
  fields = checkout_information_fields

  fields[:first_name].set('')
  fields[:last_name].set('')
  fields[:postal_code].set('')
end

def fill_checkout_information(first_name, last_name, postal_code)
  clear_checkout_information_fields

  find('#first-name', visible: true).set(first_name)
  find('#last-name', visible: true).set(last_name)
  find('#postal-code', visible: true).set(postal_code)
end

def validate_checkout_information_page
  expect(page).to have_current_path('/checkout-step-one.html', wait: 5)
  expect(page).to have_css('.title', text: 'Checkout: Your Information')
  expect(page).to have_css('#first-name', visible: true)
  expect(page).to have_css('#last-name', visible: true)
  expect(page).to have_css('#postal-code', visible: true)
  expect(page).to have_css('#continue', visible: true)
  expect(page).to have_css('#cancel', visible: true)
end

def validate_checkout_overview_page
  expect(page).to have_current_path('/checkout-step-two.html', wait: 5)
  expect(page).to have_css('.title', text: 'Checkout: Overview')
  expect(page).to have_css('.cart_item', minimum: 1)
  expect(page).to have_css('.summary_info')
  expect(page).to have_css('#finish', visible: true)
  expect(page).to have_css('#cancel', visible: true)
end

def validate_checkout_complete_page
  expect(page).to have_current_path('/checkout-complete.html', wait: 5)
  expect(page).to have_css('.title', text: 'Checkout: Complete!')
  expect(page).to have_css('.complete-header', visible: true)
  expect(page).to have_css('.complete-text', visible: true)
  expect(page).to have_css('#back-to-products', visible: true)
end

def find_cart_product(product_name)
  matching_products = all('.cart_item').select do |item|
    item.has_css?('.inventory_item_name', text: product_name, exact_text: true)
  end

  expect(matching_products.size).to eq(1)

  matching_products.first
end

def summary_item_total_text
  find('.summary_subtotal_label', visible: true).text.strip
end

def summary_tax_text
  find('.summary_tax_label', visible: true).text.strip
end

def summary_total_text
  find('.summary_total_label', visible: true).text.strip
end

def extract_money_from(text)
  match = text.match(/\$\d+\.\d{2}/)

  raise "No money amount found in text: #{text}" if match.nil?

  match[0]
end

def money_to_number(money_text)
  money_text.gsub('$', '').to_f
end

def checkout_product_prices
  all('.cart_item').map do |item|
    item.find('.inventory_item_price').text.strip.gsub('$', '').to_f
  end
end

When('I proceed to checkout') do
  expect(page).to have_current_path('/cart.html', wait: 5)
  expect(page).to have_css('.title', text: 'Your Cart')
  expect(page).to have_css('.cart_item', minimum: 1)
  expect(page).to have_css('#checkout', visible: true)

  click_css('#checkout')

  validate_checkout_information_page
end

Then('I should see the checkout information form') do
  validate_checkout_information_page
end

Then('I should see fields for first name, last name, and postal code') do
  validate_checkout_information_page

  expect(page).to have_css('#first-name', visible: true)
  expect(page).to have_css('#last-name', visible: true)
  expect(page).to have_css('#postal-code', visible: true)

  expect(find('#first-name')[:placeholder]).to eq('First Name')
  expect(find('#last-name')[:placeholder]).to eq('Last Name')
  expect(find('#postal-code')[:placeholder]).to eq('Zip/Postal Code')
end

When('I enter checkout information with first name {string}, last name {string}, and postal code {string}') do |first_name, last_name, postal_code|
  validate_checkout_information_page

  fill_checkout_information(first_name, last_name, postal_code)

  expect(find('#first-name').value).to eq(first_name)
  expect(find('#last-name').value).to eq(last_name)
  expect(find('#postal-code').value).to eq(postal_code)
end

When('I continue the checkout process') do
  validate_checkout_information_page

  click_css('#continue')
end

Then('I should see the product {string} in the checkout overview') do |product_name|
  validate_checkout_overview_page

  product_row = find_cart_product(product_name)

  expect(product_row).to have_css('.inventory_item_name', text: product_name, exact_text: true)
  expect(product_row).to have_css('.inventory_item_desc')
  expect(product_row).to have_css('.inventory_item_price')

  description = product_row.find('.inventory_item_desc').text.strip
  price = product_row.find('.inventory_item_price').text.strip

  expect(description).not_to be_empty
  expect(price).to match(/^\$\d+\.\d{2}$/)
end

When('I finish the checkout') do
  validate_checkout_overview_page

  click_css('#finish')

  validate_checkout_complete_page
end

Then('I should see the checkout completion title {string}') do |expected_title|
  validate_checkout_complete_page

  expect(page).to have_css('.title', text: expected_title)
  expect(find('.title').text.strip).to eq(expected_title)
end

Then('I should see the order confirmation message {string}') do |expected_message|
  validate_checkout_complete_page

  expect(page).to have_css('.complete-header', text: expected_message)
  expect(find('.complete-header').text.strip).to eq(expected_message)
end

Then('I should see the dispatch message {string}') do |expected_message|
  validate_checkout_complete_page

  expect(page).to have_css('.complete-text', text: expected_message)
  expect(find('.complete-text').text.strip).to include(expected_message)
end

Then('I should remain on the checkout information form') do
  validate_checkout_information_page

  expect(page).not_to have_current_path('/checkout-step-two.html')
  expect(page).not_to have_css('.title', text: 'Checkout: Overview')
end

Then('I should see a checkout error message {string}') do |expected_message|
  validate_checkout_information_page

  expect(page).to have_css('[data-test="error"]', text: expected_message, wait: 5)
  expect(find('[data-test="error"]').text.strip).to eq(expected_message)

  expect(page).to have_css('.error-button', visible: true)

  expect(page).not_to have_current_path('/checkout-step-two.html')
end

When('I cancel the checkout from the information page') do
  validate_checkout_information_page

  click_css('#cancel')
end

Then('I should return to the cart page') do
  expect(page).to have_current_path('/cart.html', wait: 5)
  expect(page).to have_css('.title', text: 'Your Cart')
  expect(page).to have_css('.cart_list')
  expect(page).to have_css('.cart_item', minimum: 1)
  expect(page).to have_css('#checkout', visible: true)
end

Then('I should still see the product {string} in the cart') do |product_name|
  expect(page).to have_current_path('/cart.html', wait: 5)
  expect(page).to have_css('.title', text: 'Your Cart')

  product_row = find_cart_product(product_name)

  expect(product_row).to have_css('.inventory_item_name', text: product_name, exact_text: true)
  expect(product_row).to have_css('.inventory_item_desc')
  expect(product_row).to have_css('.inventory_item_price')
  expect(product_row).to have_css('button', text: 'Remove')
end

When('I cancel the checkout from the overview page') do
  validate_checkout_overview_page

  click_css('#cancel')
end

Then('I should return to the products page') do
  expect(page).to have_current_path('/inventory.html', wait: 5)
  expect(page).to have_css('.title', text: 'Products')
  expect(page).to have_css('.inventory_list')
  expect(page).to have_css('.inventory_item', minimum: 1)
  expect(page).to have_css('.shopping_cart_link', visible: true)
end

Then('I should see the product catalog') do
  expect(page).to have_current_path('/inventory.html', wait: 5)
  expect(page).to have_css('.title', text: 'Products')
  expect(page).to have_css('.inventory_list')
  expect(page).to have_css('.inventory_item', minimum: 1)

  all('.inventory_item').each do |product|
    expect(product).to have_css('.inventory_item_name')
    expect(product).to have_css('.inventory_item_desc')
    expect(product).to have_css('.inventory_item_price')
    expect(product).to have_css('button')

    name = product.find('.inventory_item_name').text.strip
    description = product.find('.inventory_item_desc').text.strip
    price = product.find('.inventory_item_price').text.strip

    expect(name).not_to be_empty
    expect(description).not_to be_empty
    expect(price).to match(/^\$\d+\.\d{2}$/)
  end
end

Then('I should see the item total {string}') do |expected_item_total|
  validate_checkout_overview_page

  item_total_text = summary_item_total_text
  actual_item_total = extract_money_from(item_total_text)

  expect(item_total_text).to include('Item total:')
  expect(actual_item_total).to eq(expected_item_total)
end

Then('I should see the tax amount {string}') do |expected_tax|
  validate_checkout_overview_page

  tax_text = summary_tax_text
  actual_tax = extract_money_from(tax_text)

  expect(tax_text).to include('Tax:')
  expect(actual_tax).to eq(expected_tax)
end

Then('I should see the final total {string}') do |expected_total|
  validate_checkout_overview_page

  total_text = summary_total_text
  actual_total = extract_money_from(total_text)

  expect(total_text).to include('Total:')
  expect(actual_total).to eq(expected_total)
end

Then('the checkout total should match the visible product prices') do
  validate_checkout_overview_page

  product_subtotal = checkout_product_prices.sum.round(2)
  expected_tax = (product_subtotal * 0.08).round(2)
  expected_total = (product_subtotal + expected_tax).round(2)

  actual_item_total = money_to_number(extract_money_from(summary_item_total_text))
  actual_tax = money_to_number(extract_money_from(summary_tax_text))
  actual_total = money_to_number(extract_money_from(summary_total_text))

  expect(actual_item_total).to eq(product_subtotal)
  expect(actual_tax).to eq(expected_tax)
  expect(actual_total).to eq(expected_total)
end