When('I sort the products by {string}') do |sort_option|
  find('.product_sort_container').select(sort_option)
end

Then('the products should be displayed by name in {string} order') do |order|
  product_names = all('.inventory_item_name').map(&:text)

  expected_names =
    if order == 'ascending'
      product_names.sort
    elsif order == 'descending'
      product_names.sort.reverse
    else
      raise "Unsupported order: #{order}"
    end

  expect(product_names).to eq(expected_names)
end

Then('the products should be displayed by price in {string} order') do |order|
  product_prices = all('.inventory_item_price').map do |price_element|
    price_element.text.delete('$').to_f
  end

  expected_prices =
    if order == 'ascending'
      product_prices.sort
    elsif order == 'descending'
      product_prices.sort.reverse
    else
      raise "Unsupported order: #{order}"
    end

  expect(product_prices).to eq(expected_prices)
end