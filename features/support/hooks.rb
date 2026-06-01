
After do 
    Capybara.current_session.driver.quit
    Capybara.reset_sessions!
end

Before '@maximize' do
  page.driver.browser.manage.window.maximize
end

