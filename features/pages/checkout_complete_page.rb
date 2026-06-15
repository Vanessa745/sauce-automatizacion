# features/pages/checkout_complete_page.rb

class CheckoutCompletePage
  include Capybara::DSL
  include RSpec::Matchers

  CHECKOUT_COMPLETE_PATH = '/checkout-complete.html'

  PAGE_TITLE = '.title'
  COMPLETE_HEADER = '.complete-header'
  COMPLETE_TEXT = '.complete-text'
  BACK_TO_PRODUCTS_BUTTON = '#back-to-products'

  def validate_page
    expect(page).to have_current_path(CHECKOUT_COMPLETE_PATH, wait: 5)
    expect(page).to have_css(PAGE_TITLE, text: 'Checkout: Complete!')
    expect(page).to have_css(COMPLETE_HEADER, visible: true)
    expect(page).to have_css(COMPLETE_TEXT, visible: true)
    expect(page).to have_css(BACK_TO_PRODUCTS_BUTTON, visible: true)
  end

  def validate_completion_title(expected_title)
    validate_page

    expect(page).to have_css(PAGE_TITLE, text: expected_title)
    expect(find(PAGE_TITLE).text.strip).to eq(expected_title)
  end

  def validate_order_confirmation_message(expected_message)
    validate_page

    expect(page).to have_css(COMPLETE_HEADER, text: expected_message)
    expect(find(COMPLETE_HEADER).text.strip).to eq(expected_message)
  end

  def validate_dispatch_message(expected_message)
    validate_page

    expect(page).to have_css(COMPLETE_TEXT, text: expected_message)
    expect(find(COMPLETE_TEXT).text.strip).to include(expected_message)
  end
end