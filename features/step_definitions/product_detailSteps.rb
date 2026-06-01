When('I save the catalog information for product {string}') do |product_name|
  product_card = all('.inventory_item').find do |item|
    item.has_text?(product_name)
  end

  @catalog_product_name = product_card.find('.inventory_item_name').text
  @catalog_product_description = product_card.find('.inventory_item_desc').text
  @catalog_product_price = product_card.find('.inventory_item_price').text
end

When('I open the detail page for product {string}') do |product_name|
  product_card = all('.inventory_item').find do |item|
    item.has_text?(product_name)
  end

  product_card.find('.inventory_item_name').click
end

Then('the product detail information should match the catalog information') do
  detail_name = find('.inventory_details_name').text
  detail_description = find('.inventory_details_desc').text
  detail_price = find('.inventory_details_price').text

  expect(detail_name).to eq(@catalog_product_name)
  expect(detail_description).to eq(@catalog_product_description)
  expect(detail_price).to eq(@catalog_product_price)
end

Then('I return to the products page') do
  click_button 'Back to products'

  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_content('Products')
end