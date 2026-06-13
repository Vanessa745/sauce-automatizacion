class CartPage
  include Capybara::DSL
  include RSpec::Matchers

  CART_PATH = '/cart.html'

  PAGE_TITLE = '.title'
  CART_LIST = '.cart_list'
  CART_ITEM = '.cart_item'
  PRODUCT_NAME = '.inventory_item_name'
  PRODUCT_DESCRIPTION = '.inventory_item_desc'
  PRODUCT_PRICE = '.inventory_item_price'
  CHECKOUT_BUTTON = '#checkout'

  def validate_cart_page
    expect(page).to have_current_path(CART_PATH, wait: 5)
    expect(page).to have_css(PAGE_TITLE, exact_text: 'Your Cart')
    expect(page).to have_css(CART_LIST)
  end

  def cart_items
    all(CART_ITEM)
  end

  def cart_item_by_name(product_name)
    cart_items.find do |item|
      item.has_css?(PRODUCT_NAME, text: product_name, exact_text: true)
    end
  end

  def validate_product_in_cart(product_name)
    validate_cart_page

    product = cart_item_by_name(product_name)

    raise "Product not found in cart: #{product_name}" if product.nil?

    expect(product).to have_css(PRODUCT_NAME, text: product_name, exact_text: true)
    expect(product).to have_css(PRODUCT_DESCRIPTION)
    expect(product).to have_css(PRODUCT_PRICE)

    description = product.find(PRODUCT_DESCRIPTION).text.strip
    price = product.find(PRODUCT_PRICE).text.strip

    expect(description).not_to be_empty
    expect(price).to match(/^\$\d+\.\d{2}$/)
  end

  def validate_product_count(expected_count)
    validate_cart_page
    expect(cart_items.size).to eq(expected_count)
  end

  def validate_checkout_button_visible
    validate_cart_page
    expect(page).to have_css(CHECKOUT_BUTTON, visible: true)
  end
end