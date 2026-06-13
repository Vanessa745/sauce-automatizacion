class ProductDetailPage
  include Capybara::DSL
  include RSpec::Matchers

  PRODUCT_DETAIL_PATH_PATTERN = %r{/inventory-item\.html\?id=\d+}

  DETAIL_NAME = '.inventory_details_name'
  DETAIL_DESCRIPTION = '.inventory_details_desc'
  DETAIL_PRICE = '.inventory_details_price'
  BACK_TO_PRODUCTS_BUTTON = '#back-to-products'

  PRODUCTS_PATH = '/inventory.html'
  PRODUCTS_TITLE = '.title'
  INVENTORY_LIST = '.inventory_list'
  INVENTORY_ITEM = '.inventory_item'

  def validate_detail_page
    expect(page).to have_current_path(PRODUCT_DETAIL_PATH_PATTERN, url: false, wait: 5)
    expect(page).to have_css(DETAIL_NAME, visible: true)
    expect(page).to have_css(DETAIL_DESCRIPTION, visible: true)
    expect(page).to have_css(DETAIL_PRICE, visible: true)
    expect(page).to have_css(BACK_TO_PRODUCTS_BUTTON, visible: true)
  end

  def detail_product_information
    validate_detail_page

    {
      name: find(DETAIL_NAME).text.strip,
      description: find(DETAIL_DESCRIPTION).text.strip,
      price: find(DETAIL_PRICE).text.strip
    }
  end

  def validate_information_matches_catalog(catalog_information)
    detail_information = detail_product_information

    expect(detail_information[:name]).to eq(catalog_information[:name])
    expect(detail_information[:description]).to eq(catalog_information[:description])
    expect(detail_information[:price]).to eq(catalog_information[:price])

    expect(detail_information[:name]).not_to be_empty
    expect(detail_information[:description]).not_to be_empty
    expect(detail_information[:price]).to match(/^\$\d+\.\d{2}$/)
  end

  def return_to_products_page
    validate_detail_page

    click_button('Back to products')

    validate_products_page
  end

  def validate_products_page
    expect(page).to have_current_path(PRODUCTS_PATH, wait: 5)
    expect(page).to have_css(PRODUCTS_TITLE, exact_text: 'Products')
    expect(page).to have_css(INVENTORY_LIST)
    expect(page).to have_css(INVENTORY_ITEM, minimum: 1)
  end
end