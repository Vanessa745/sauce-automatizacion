require 'fileutils'

After do 
  Capybara.current_session.driver.quit
  Capybara.reset_sessions!
end

After do |scenario|
  if scenario.failed?
    timestamp = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
    scenario_name = scenario.name.gsub(/[^A-Za-z0-9_]/, '_')

    screenshot_path = "reports/screenshots/#{scenario_name}_#{timestamp}.png"
    html_path = "reports/screenshots/#{scenario_name}_#{timestamp}.html"

    save_screenshot(screenshot_path)
    save_page(html_path)
  end
end

Before '@maximize' do
  page.driver.browser.manage.window.maximize
end

Before do 
  FileUtils.mkdir_p('reports/screenshots')
end

