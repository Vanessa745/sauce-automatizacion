class CheckoutInformationPage
  include Capybara::DSL
  include RSpec::Matchers

  CHECKOUT_INFORMATION_PATH = '/checkout-step-one.html'

  PAGE_TITLE = '.title'
  FIRST_NAME_FIELD = '#first-name'
  LAST_NAME_FIELD = '#last-name'
  POSTAL_CODE_FIELD = '#postal-code'
  CONTINUE_BUTTON = '#continue'
  CANCEL_BUTTON = '#cancel'
  ERROR_MESSAGE = '[data-test="error"]'
  ERROR_BUTTON = '.error-button'

  def validate_page
    expect(page).to have_current_path(CHECKOUT_INFORMATION_PATH, wait: 5)
    expect(page).to have_css(PAGE_TITLE, text: 'Checkout: Your Information')
    expect(page).to have_css(FIRST_NAME_FIELD, visible: true)
    expect(page).to have_css(LAST_NAME_FIELD, visible: true)
    expect(page).to have_css(POSTAL_CODE_FIELD, visible: true)
    expect(page).to have_css(CONTINUE_BUTTON, visible: true)
    expect(page).to have_css(CANCEL_BUTTON, visible: true)
  end

  def validate_required_fields
    validate_page

    expect(find(FIRST_NAME_FIELD)[:placeholder]).to eq('First Name')
    expect(find(LAST_NAME_FIELD)[:placeholder]).to eq('Last Name')
    expect(find(POSTAL_CODE_FIELD)[:placeholder]).to eq('Zip/Postal Code')
  end

  def fill_information(first_name, last_name, postal_code)
    validate_page

    find(FIRST_NAME_FIELD, visible: true).set('')
    find(LAST_NAME_FIELD, visible: true).set('')
    find(POSTAL_CODE_FIELD, visible: true).set('')

    find(FIRST_NAME_FIELD, visible: true).set(first_name)
    find(LAST_NAME_FIELD, visible: true).set(last_name)
    find(POSTAL_CODE_FIELD, visible: true).set(postal_code)

    expect(find(FIRST_NAME_FIELD).value).to eq(first_name)
    expect(find(LAST_NAME_FIELD).value).to eq(last_name)
    expect(find(POSTAL_CODE_FIELD).value).to eq(postal_code)
  end

  def continue_checkout
    validate_page

    click_button('Continue')
  end

  def cancel_checkout
    validate_page

    click_button('Cancel')
  end

  def validate_user_remains_on_form
    validate_page

    expect(page).not_to have_current_path('/checkout-step-two.html')
    expect(page).not_to have_css(PAGE_TITLE, text: 'Checkout: Overview')
  end

  def validate_error_message(expected_message)
    validate_page

    expect(page).to have_css(ERROR_MESSAGE, text: expected_message, wait: 5)
    expect(find(ERROR_MESSAGE).text.strip).to eq(expected_message)
    expect(page).to have_css(ERROR_BUTTON, visible: true)
    expect(page).not_to have_current_path('/checkout-step-two.html')
  end
end