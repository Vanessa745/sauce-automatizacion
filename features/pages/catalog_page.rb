class CatalogPage
  include Capybara::DSL
  include RSpec::Matchers

  PRODUCTS_PATH = '/inventory.html'

  PAGE_TITLE = '.title'
  INVENTORY_LIST = '.inventory_list'
  PRODUCT_CARD = '.inventory_item'
  PRODUCT_NAME = '.inventory_item_name'
  PRODUCT_DESCRIPTION = '.inventory_item_desc'
  PRODUCT_PRICE = '.inventory_item_price'
  SORT_DROPDOWN = 'select.product_sort_container'

  SORT_VALUES = {
    'Name (A to Z)' => 'az',
    'Name (Z to A)' => 'za',
    'Price (low to high)' => 'lohi',
    'Price (high to low)' => 'hilo'
  }

  def validate_products_page
    expect(page).to have_current_path(PRODUCTS_PATH, wait: 5)
    expect(page).to have_css(PAGE_TITLE, text: 'Products')
    expect(page).to have_css(INVENTORY_LIST)
    expect(page).to have_css(PRODUCT_CARD, minimum: 1)
    expect(page).to have_css(SORT_DROPDOWN)
  end

  def product_cards
    all(PRODUCT_CARD)
  end

  def product_count
    product_cards.size
  end

  def product_names
    product_cards.map do |product|
      product.find(PRODUCT_NAME).text.strip
    end
  end

  def product_prices_text
    product_cards.map do |product|
      product.find(PRODUCT_PRICE).text.strip
    end
  end

  def product_prices_numeric
    product_prices_text.map do |price|
      normalize_price(price)
    end
  end

  def first_product_name
    product_cards.first.find(PRODUCT_NAME).text.strip
  end

  def first_product_price
    product_cards.first.find(PRODUCT_PRICE).text.strip
  end

  def normalize_price(price)
    price.gsub('$', '').to_f
  end

  def select_sort_option(sort_option)
    validate_products_page
    validate_products_are_visible_and_complete
    validate_no_duplicate_product_names

    sort_dropdown.select(sort_option)

    expected_value = selected_sort_value_for(sort_option)
    actual_value = sort_dropdown.value

    expect(actual_value).to eq(expected_value)
  end

  def validate_first_product(expected_product)
    validate_products_are_visible_and_complete

    expect(first_product_name).to eq(expected_product)
    expect(product_names).to include(expected_product)
  end

  def validate_first_product_price(expected_price)
    validate_products_are_visible_and_complete

    expect(first_product_price).to eq(expected_price)
    expect(first_product_price).to match(/^\$\d+\.\d{2}$/)
    expect(normalize_price(first_product_price)).to eq(normalize_price(expected_price))
  end

  def validate_products_sorted_by_name(expected_order)
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

  def validate_products_sorted_by_price(expected_order)
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
      name = product.find(PRODUCT_NAME).text.strip
      price_text = product.find(PRODUCT_PRICE).text.strip
      price_number = normalize_price(price_text)

      expect(name).not_to be_empty
      expect(price_text).to match(/^\$\d+\.\d{2}$/)
      expect(price_number).to be > 0
    end
  end

  def validate_products_are_visible_and_complete
    expect(product_cards.size).to be > 0

    product_cards.each do |product|
      expect(product).to have_css(PRODUCT_NAME)
      expect(product).to have_css(PRODUCT_DESCRIPTION)
      expect(product).to have_css(PRODUCT_PRICE)
      expect(product).to have_css('button')

      name = product.find(PRODUCT_NAME).text.strip
      description = product.find(PRODUCT_DESCRIPTION).text.strip
      price = product.find(PRODUCT_PRICE).text.strip
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

  # Métodos relacionados con la gestión del carrito de compras

  def product_card_by_name(product_name)
    product_cards.find do |product|
      product.has_css?(PRODUCT_NAME, text: product_name, exact_text: true)
    end
  end

  def validate_product_exists(product_name)
    product = product_card_by_name(product_name)

    raise "Product not found on products page: #{product_name}" if product.nil?

    expect(product).to have_css(PRODUCT_NAME, text: product_name, exact_text: true)
    expect(product).to have_css(PRODUCT_DESCRIPTION)
    expect(product).to have_css(PRODUCT_PRICE)
    expect(product).to have_css('button')

    product
  end

  def add_product_to_cart(product_name)
    product = validate_product_exists(product_name)

    within(product) do
      expect(page).to have_button('Add to cart')
      click_button('Add to cart')
      expect(page).to have_button('Remove')
    end
  end

  def remove_product_from_products_page(product_name)
    product = validate_product_exists(product_name)

    within(product) do
      expect(page).to have_button('Remove')
      click_button('Remove')
      expect(page).to have_button('Add to cart')
    end
  end

  def validate_product_button_text(product_name, expected_button_text)
    product = validate_product_exists(product_name)

    within(product) do
      expect(page).to have_css(PRODUCT_NAME, text: product_name, exact_text: true)
      expect(page).to have_button(expected_button_text, exact_text: expected_button_text)
    end
  end

  def open_shopping_cart
    expect(page).to have_css('.shopping_cart_link', visible: true)
    find('.shopping_cart_link').click
  end

  def validate_cart_badge(expected_quantity)
    expect(page).to have_css('.shopping_cart_badge', exact_text: expected_quantity)
  end

  def validate_cart_badge_not_visible
    expect(page).to have_no_css('.shopping_cart_badge')
  end

  # Métodos relacionados con la gestión del checkout

  def validate_product_catalog
    validate_products_page
    validate_products_are_visible_and_complete
  end

  # Métodos relacionados con el detalle del producto

  def catalog_product_information(product_name)
    validate_products_page

    product = validate_product_exists(product_name)

    {
      name: product.find(PRODUCT_NAME).text.strip,
      description: product.find(PRODUCT_DESCRIPTION).text.strip,
      price: product.find(PRODUCT_PRICE).text.strip
    }
  end

  def open_product_detail(product_name)
    validate_products_page

    product = validate_product_exists(product_name)

    product.find(PRODUCT_NAME).click
  end

  private

  def sort_dropdown
    find(SORT_DROPDOWN)
  end

  def selected_sort_value_for(sort_option)
    SORT_VALUES[sort_option]
  end
end