class CheckoutOverviewPage
  include Capybara::DSL
  include RSpec::Matchers

  CHECKOUT_OVERVIEW_PATH = '/checkout-step-two.html'

  PAGE_TITLE = '.title'
  CART_ITEM = '.cart_item'
  PRODUCT_NAME = '.inventory_item_name'
  PRODUCT_DESCRIPTION = '.inventory_item_desc'
  PRODUCT_PRICE = '.inventory_item_price'
  SUMMARY_INFO = '.summary_info'
  ITEM_TOTAL = '.summary_subtotal_label'
  TAX = '.summary_tax_label'
  FINAL_TOTAL = '.summary_total_label'
  FINISH_BUTTON = '#finish'
  CANCEL_BUTTON = '#cancel'

  def validate_page
    expect(page).to have_current_path(CHECKOUT_OVERVIEW_PATH, wait: 5)
    expect(page).to have_css(PAGE_TITLE, text: 'Checkout: Overview')
    expect(page).to have_css(CART_ITEM, minimum: 1)
    expect(page).to have_css(SUMMARY_INFO)
    expect(page).to have_css(FINISH_BUTTON, visible: true)
    expect(page).to have_css(CANCEL_BUTTON, visible: true)
  end

  def cart_items
    all(CART_ITEM)
  end

  def find_product(product_name)
    matching_products = cart_items.select do |item|
      item.has_css?(PRODUCT_NAME, text: product_name, exact_text: true)
    end

    expect(matching_products.size).to eq(1)

    matching_products.first
  end

  def validate_product(product_name)
    validate_page

    product = find_product(product_name)

    expect(product).to have_css(PRODUCT_NAME, text: product_name, exact_text: true)
    expect(product).to have_css(PRODUCT_DESCRIPTION)
    expect(product).to have_css(PRODUCT_PRICE)

    description = product.find(PRODUCT_DESCRIPTION).text.strip
    price = product.find(PRODUCT_PRICE).text.strip

    expect(description).not_to be_empty
    expect(price).to match(/^\$\d+\.\d{2}$/)
  end

  def finish_checkout
    validate_page

    click_button('Finish')
  end

  def cancel_checkout
    validate_page

    click_button('Cancel')
  end

  def validate_item_total(expected_item_total)
    validate_page

    item_total_text = summary_item_total_text
    actual_item_total = extract_money_from(item_total_text)

    expect(item_total_text).to include('Item total:')
    expect(actual_item_total).to eq(expected_item_total)
  end

  def validate_tax(expected_tax)
    validate_page

    tax_text = summary_tax_text
    actual_tax = extract_money_from(tax_text)

    expect(tax_text).to include('Tax:')
    expect(actual_tax).to eq(expected_tax)
  end

  def validate_final_total(expected_total)
    validate_page

    total_text = summary_total_text
    actual_total = extract_money_from(total_text)

    expect(total_text).to include('Total:')
    expect(actual_total).to eq(expected_total)
  end

  def validate_total_matches_visible_product_prices
    validate_page

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

  private

  def summary_item_total_text
    find(ITEM_TOTAL, visible: true).text.strip
  end

  def summary_tax_text
    find(TAX, visible: true).text.strip
  end

  def summary_total_text
    find(FINAL_TOTAL, visible: true).text.strip
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
    cart_items.map do |item|
      item.find(PRODUCT_PRICE).text.strip.gsub('$', '').to_f
    end
  end
end