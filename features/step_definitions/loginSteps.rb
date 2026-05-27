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

Then('I should see the products page') do
  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_content('Products')
end

Then('I should see {string} error message') do |error_message|
  # expect(page).to have_css('[data-test="error"]')
  expect(page).to have_content(error_message)
end

# Then('I should see a locked out user error message') do
#   expect(page).to have_content('Epic sadface: Sorry, this user has been locked out.')
# end

# Then('I should see a username required error message') do
#   expect(page).to have_content('Epic sadface: Username is required')
# end