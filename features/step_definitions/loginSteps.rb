Given('I am on the SauceDemo login page') do
  visit('https://www.saucedemo.com/')
end

When('I enter the username {string}') do |username|
  fill_in('user-name', with: username)
end

When('I enter the password {string}') do |password|
  fill_in('password', with: password)
end

When('I click the login button') do
  click_button('login-button')
end

Then('I should see the login result {string} with message {string}') do |result, message|
  if result == 'success'
    expect(page).to have_current_path('/inventory.html')

    expect(page).to have_css('.title', exact_text: message)
    expect(page).to have_css('.inventory_list')
    expect(page).to have_css('.inventory_item', minimum: 1)
  else
    expect(page).to have_current_path('/')
    expect(page).to have_css('[data-test="error"]', text: message)
  end
end