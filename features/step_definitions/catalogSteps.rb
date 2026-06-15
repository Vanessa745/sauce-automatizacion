def product_cards
  all('.inventory_item')
end

def sort_dropdown
  find('select.product_sort_container')
end

def product_names
  product_cards.map do |product|
    product.find('.inventory_item_name').text.strip
  end
end

def product_prices_text
  product_cards.map do |product|
    product.find('.inventory_item_price').text.strip
  end
end

def product_prices_numeric
  product_prices_text.map do |price|
    price.gsub('$', '').to_f
  end
end

def first_product_name
  product_cards.first.find('.inventory_item_name').text.strip
end

def first_product_price
  product_cards.first.find('.inventory_item_price').text.strip
end

def normalize_price(price)
  price.gsub('$', '').to_f
end

def selected_sort_value_for(sort_option)
  {
    'Name (A to Z)' => 'az',
    'Name (Z to A)' => 'za',
    'Price (low to high)' => 'lohi',
    'Price (high to low)' => 'hilo'
  }[sort_option]
end

def validate_products_are_visible_and_complete
  expect(product_cards.size).to be > 0

  product_cards.each do |product|
    expect(product).to have_css('.inventory_item_name')
    expect(product).to have_css('.inventory_item_desc')
    expect(product).to have_css('.inventory_item_price')
    expect(product).to have_css('button')

    name = product.find('.inventory_item_name').text.strip
    description = product.find('.inventory_item_desc').text.strip
    price = product.find('.inventory_item_price').text.strip
    button_text = product.find('button').text.strip

    expect(name).not_to be_empty
    expect(description).not_to be_empty
    expect(price).to match(/^\$\d+\.\d{2}$/)
    expect(button_text).not_to be_empty
  end
end

def validate_no_duplicate_product_names
  names = product_names
  expect(names.uniq.size).to eq(names.size)
end

def validate_product_count_was_not_modified
  expect(product_cards.size).to eq(@product_count_before_sort)
end

When('I select the sort option {string}') do |sort_option|
  expect(page).to have_css('.inventory_item', minimum: 1)
  expect(page).to have_css('select.product_sort_container')

  @product_count_before_sort = product_cards.size

  validate_products_are_visible_and_complete
  validate_no_duplicate_product_names

  sort_dropdown.select(sort_option)

  expected_value = selected_sort_value_for(sort_option)
  actual_value = sort_dropdown.value

  expect(actual_value).to eq(expected_value)
end

Then('the first product displayed should be {string}') do |expected_product|
  validate_product_count_was_not_modified
  validate_products_are_visible_and_complete

  expect(first_product_name).to eq(expected_product)
  expect(product_names).to include(expected_product)
end

Then('the first product price should be {string}') do |expected_price|
  validate_product_count_was_not_modified
  validate_products_are_visible_and_complete

  expect(first_product_price).to eq(expected_price)
  expect(first_product_price).to match(/^\$\d+\.\d{2}$/)
  expect(normalize_price(first_product_price)).to eq(normalize_price(expected_price))
end

Then('the products should be displayed by name {string}') do |expected_order|
  validate_product_count_was_not_modified
  validate_products_are_visible_and_complete
  validate_no_duplicate_product_names

  actual_names = product_names

  expected_names =
    case expected_order
    when 'from A to Z'
      actual_names.sort
    when 'from Z to A'
      actual_names.sort.reverse
    else
      raise "Unsupported name order: #{expected_order}"
    end

  expect(actual_names).to eq(expected_names)
end

Then('the products should be displayed by price {string}') do |expected_order|
  validate_product_count_was_not_modified
  validate_products_are_visible_and_complete
  validate_no_duplicate_product_names

  actual_prices = product_prices_numeric

  expected_prices =
    case expected_order
    when 'from lowest to highest'
      actual_prices.sort
    when 'from highest to lowest'
      actual_prices.sort.reverse
    else
      raise "Unsupported price order: #{expected_order}"
    end

  expect(actual_prices).to eq(expected_prices)

  product_cards.each do |product|
    name = product.find('.inventory_item_name').text.strip
    price_text = product.find('.inventory_item_price').text.strip
    price_number = normalize_price(price_text)

    expect(name).not_to be_empty
    expect(price_text).to match(/^\$\d+\.\d{2}$/)
    expect(price_number).to be > 0
  end
end