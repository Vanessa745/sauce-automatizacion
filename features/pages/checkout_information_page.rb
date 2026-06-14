class CheckoutInformationPage
  include Capybara::DSL
  include RSpec::Matchers

  CHECKOUT_INFORMATION_PATH = '/checkout-step-one.html'
  CHECKOUT_OVERVIEW_PATH = '/checkout-step-two.html'
  CART_PATH = '/cart.html'
  LOGIN_PATH = '/'

  PAGE_TITLE = '.title'

  CHECKOUT_INFO_CONTAINER = '.checkout_info'
  CHECKOUT_INFO_WRAPPER = '.checkout_info_wrapper'
  FORM_GROUP = '.form_group'
  CHECKOUT_BUTTONS = '.checkout_buttons'

  FIRST_NAME_FIELD = '#first-name'
  LAST_NAME_FIELD = '#last-name'
  POSTAL_CODE_FIELD = '#postal-code'

  CONTINUE_BUTTON = '#continue'
  CANCEL_BUTTON = '#cancel'

  ERROR_MESSAGE = '[data-test="error"]'
  ERROR_BUTTON = '.error-button'

  SHOPPING_CART_LINK = '.shopping_cart_link'
  MENU_BUTTON = '#react-burger-menu-btn'

  def validate_page
    # Valida que el usuario está exactamente en la página de información del checkout
    expect(page).to have_current_path(CHECKOUT_INFORMATION_PATH, ignore_query: true, wait: 5)

    # Valida que no fue redirigido a otra pantalla del flujo
    expect(page).not_to have_current_path(LOGIN_PATH, ignore_query: true)
    expect(page).not_to have_current_path(CART_PATH, ignore_query: true)
    expect(page).not_to have_current_path(CHECKOUT_OVERVIEW_PATH, ignore_query: true)

    # Valida identidad visual y estructural de la página
    expect(page).to have_css(PAGE_TITLE, exact_text: 'Checkout: Your Information', visible: true)
    expect(page).to have_css(CHECKOUT_INFO_CONTAINER, visible: true)
    expect(page).to have_css(CHECKOUT_INFO_WRAPPER, visible: true)
    expect(page).to have_css(FORM_GROUP, count: 3)

    # Valida que siguen existiendo elementos propios de una sesión activa
    expect(page).to have_css(SHOPPING_CART_LINK, visible: true)
    expect(page).to have_css(MENU_BUTTON, visible: true)

    # Valida campos obligatorios del formulario
    validate_input_field(
      FIRST_NAME_FIELD,
      expected_name: 'firstName',
      expected_placeholder: 'First Name'
    )

    validate_input_field(
      LAST_NAME_FIELD,
      expected_name: 'lastName',
      expected_placeholder: 'Last Name'
    )

    validate_input_field(
      POSTAL_CODE_FIELD,
      expected_name: 'postalCode',
      expected_placeholder: 'Zip/Postal Code'
    )

    # Valida botones de acción
    expect(page).to have_css(CHECKOUT_BUTTONS, visible: true)

    cancel_button = find(CANCEL_BUTTON, visible: true)
    expect(cancel_button.text.strip).to eq('Cancel')
    expect(cancel_button.disabled?).to be(false)

    continue_button = find(CONTINUE_BUTTON, visible: true)
    expect(continue_button[:value]).to eq('Continue')
    expect(continue_button[:type]).to eq('submit')
    expect(continue_button.disabled?).to be(false)
  end

  def validate_input_field(selector, expected_name:, expected_placeholder:)
    field = find(selector, visible: true)

    expect(field[:type]).to eq('text')
    expect(field[:name]).to eq(expected_name)
    expect(field[:placeholder]).to eq(expected_placeholder)
    expect(field.disabled?).to be(false)
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

    expect(page).not_to have_current_path(CHECKOUT_OVERVIEW_PATH, ignore_query: true)
    expect(page).not_to have_css(PAGE_TITLE, text: 'Checkout: Overview')
  end

  def validate_error_message(expected_message)
    validate_page

    expect(page).to have_css(ERROR_MESSAGE, text: expected_message, wait: 5)
    expect(find(ERROR_MESSAGE).text.strip).to eq(expected_message)
    expect(page).to have_css(ERROR_BUTTON, visible: true)
    expect(page).not_to have_current_path(CHECKOUT_OVERVIEW_PATH, ignore_query: true)
  end
end