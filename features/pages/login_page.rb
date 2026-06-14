class LoginPage
  include Capybara::DSL
  include RSpec::Matchers

  URL = 'https://www.saucedemo.com/'

  USERNAME_FIELD = 'user-name'
  PASSWORD_FIELD = 'password'
  LOGIN_BUTTON = 'login-button'

  USERNAME_FIELD_CSS = '#user-name'
  PASSWORD_FIELD_CSS = '#password'
  LOGIN_BUTTON_CSS = '#login-button'

  ERROR_MESSAGE = '[data-test="error"]'

  INVENTORY_PATH = '/inventory.html'
  LOGIN_PATH = '/'

  PRODUCTS_TITLE = '.title'
  INVENTORY_LIST = '.inventory_list'
  INVENTORY_ITEM = '.inventory_item'
  INVENTORY_ITEM_NAME = '.inventory_item_name'
  INVENTORY_ITEM_DESC = '.inventory_item_desc'
  INVENTORY_ITEM_PRICE = '.inventory_item_price'
  ADD_TO_CART_BUTTON = 'button[id^="add-to-cart"]'

  SHOPPING_CART_LINK = '.shopping_cart_link'
  MENU_BUTTON = '#react-burger-menu-btn'

  EXPECTED_PRODUCTS_COUNT = 6

  def open
    visit(URL)
  end

  def enter_username(username)
    fill_in(USERNAME_FIELD, with: username)
  end

  def enter_password(password)
    fill_in(PASSWORD_FIELD, with: password)
  end

  def click_login_button
    click_button(LOGIN_BUTTON)
  end

  def validate_successful_login(expected_message)
    expect(page).to have_current_path(INVENTORY_PATH, ignore_query: true, wait: 5)

    expect(page).to have_no_css(USERNAME_FIELD_CSS, visible: true)
    expect(page).to have_no_css(PASSWORD_FIELD_CSS, visible: true)
    expect(page).to have_no_css(LOGIN_BUTTON_CSS, visible: true)
    expect(page).to have_no_css(ERROR_MESSAGE, visible: true)

    expect(page).to have_css(PRODUCTS_TITLE, exact_text: expected_message, visible: true)
    expect(page).to have_css(SHOPPING_CART_LINK, visible: true)
    expect(page).to have_css(MENU_BUTTON, visible: true)

    expect(page).to have_css(INVENTORY_LIST, visible: true)
    expect(page).to have_css(INVENTORY_ITEM, count: EXPECTED_PRODUCTS_COUNT)

    all(INVENTORY_ITEM).each do |product|
      expect(product).to have_css(INVENTORY_ITEM_NAME, visible: true)
      expect(product).to have_css(INVENTORY_ITEM_DESC, visible: true)
      expect(product).to have_css(INVENTORY_ITEM_PRICE, visible: true)
      expect(product).to have_css(ADD_TO_CART_BUTTON, visible: true)
    end
  end

  def validate_failed_login(expected_message)
    expect(page).to have_current_path(LOGIN_PATH, wait: 5)
    expect(page).to have_css(ERROR_MESSAGE, text: expected_message)
    expect(find(ERROR_MESSAGE).text.strip).to eq(expected_message)
  end

  def validate_login_result(result, message)
    if result == 'success'
      validate_successful_login(message)
    elsif result == 'error'
      validate_failed_login(message)
    else
      raise "Unsupported login result: #{result}"
    end
  end
end