When('I save the catalog information for product {string}') do |product_name|
  @catalog_page ||= CatalogPage.new

  @catalog_page.validate_products_page
  @catalog_product_information = @catalog_page.catalog_product_information(product_name)
end

When('I open the detail page for product {string}') do |product_name|
  @catalog_page ||= CatalogPage.new

  @catalog_page.open_product_detail(product_name)

  @product_detail_page = ProductDetailPage.new
  @product_detail_page.validate_detail_page
end

Then('the product detail information should match the catalog information') do
  @product_detail_page ||= ProductDetailPage.new

  @product_detail_page.validate_information_matches_catalog(@catalog_product_information)
end

Then('I return to the products page') do
  @product_detail_page ||= ProductDetailPage.new

  @product_detail_page.return_to_products_page

  @catalog_page = CatalogPage.new
  @catalog_page.validate_products_page
end