class LoginPage
  include Capybara::DSL
  include RSpec::Matchers

  URL = 'https://www.saucedemo.com/'

  USERNAME_FIELD = 'user-name'
  PASSWORD_FIELD = 'password'
  LOGIN_BUTTON = 'login-button'

  ERROR_MESSAGE = '[data-test="error"]'

  INVENTORY_PATH = '/inventory.html'
  LOGIN_PATH = '/'

  PRODUCTS_TITLE = '.title'
  INVENTORY_LIST = '.inventory_list'
  INVENTORY_ITEM = '.inventory_item'

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
    expect(page).to have_current_path(INVENTORY_PATH, wait: 5)
    expect(page).to have_css(PRODUCTS_TITLE, exact_text: expected_message)
    expect(page).to have_css(INVENTORY_LIST)
    expect(page).to have_css(INVENTORY_ITEM, minimum: 1)
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