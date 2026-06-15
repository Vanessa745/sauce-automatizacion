When('I select the sort option {string}') do |sort_option|
  @catalog_page = CatalogPage.new

  @catalog_page.validate_products_page
  @product_count_before_sort = @catalog_page.product_count

  @catalog_page.select_sort_option(sort_option)
end

Then('the first product displayed should be {string}') do |expected_product|
  @catalog_page ||= CatalogPage.new

  expect(@catalog_page.product_count).to eq(@product_count_before_sort)

  @catalog_page.validate_first_product(expected_product)
end

Then('the first product price should be {string}') do |expected_price|
  @catalog_page ||= CatalogPage.new

  expect(@catalog_page.product_count).to eq(@product_count_before_sort)

  @catalog_page.validate_first_product_price(expected_price)
end

Then('the products should be displayed by name {string}') do |expected_order|
  @catalog_page ||= CatalogPage.new

  expect(@catalog_page.product_count).to eq(@product_count_before_sort)

  @catalog_page.validate_products_sorted_by_name(expected_order)
end

Then('the products should be displayed by price {string}') do |expected_order|
  @catalog_page ||= CatalogPage.new

  expect(@catalog_page.product_count).to eq(@product_count_before_sort)

  @catalog_page.validate_products_sorted_by_price(expected_order)
end