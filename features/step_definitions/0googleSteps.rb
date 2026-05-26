#Then I see a link for the "SIAA"
Then('I see a link for the {string}') do |ucbLink|
  expect(page).to have_link(ucbLink)
end


#Then UCB is located at "M.M.Marques, Cochabamba" street
Then(/^I see that the UCB is located at "([^"]*)" street$/) do |adUCB|
  address = find(:xpath, '/html/body/div[7]/div/div[10]/div[2]/div/div/div[2]/div/div[3]/div/div/div/div/div[1]/div/div/div/div/div[4]/div/div/div/span[2]')
  if address.text != adUCB
    	raise "UCB address should be"+adUCB	
    end
end

#And I see text about working hours "Atención de lunes a viernes de 08:30 a 15:30"
Then('I see text about working hours {string}') do |workingHoursUCB|
  workingHoursLabel = find(:xpath, '//*[@id="wrapper"]/div[2]/div[1]/div/div[3]/div/ul/li[1]/div/p')
  puts "ONLY FOR TEST PURPOSES:"+workingHoursLabel.text
  if workingHoursLabel.text != workingHoursUCB
    	raise "Working hours should be"+workingHoursUCB	
  end
end

#And I see a direct link for "Calendario Académico"
Then('I see a direct link for {string}') do |directLinkText|
  directLinkUIXPath = find(:xpath, '//*[@id="post-27463"]/div/div[1]/div/div[1]/div/div[2]/a/span[2]')
  puts "ONLY FOR TEST PURPOSES:"+directLinkUIXPath.text
  if directLinkUIXPath.text != directLinkText
      raise "Working hours should be"+directLinkText 
  end
end

#Given I browse to the UCB page
Given('I browse to the UCB page') do
  page.driver.browser.manage.window.maximize
  visit ('/')
end

#Then all links are visible so I close the page
Then('all links are visible so I close the page') do
    Capybara.current_session.driver.quit
end

#Given I am on the Dynamo homepage
Given('I am on the Dynamo homepage') do
   page.driver.browser.manage.window.maximize
  visit ('https://www.houstondynamofc.com')
  sleep 2
  click_button('Accept & Continue')
end

# When I press the "Club" link
When('I press the {string} link') do |linkName|
  click_link(linkName)
end

#Then I see that information show below
Then('I see that information show below') do |table|
  data = table.rows_hash
  counter = 2
  xpathName = '/html/body/div[1]/main/section/div/div[1]/section/div/div/div/div/article/div/div/div[1]/div[%i]/p'
  data.each_pair do |key, value|
     puts "Only for test PURPOSES"
     puts(key+" - "+value) 
     puts(find(:xpath, xpathName % [counter]).text)
     expect(find(:xpath, xpathName % [counter])).to have_content(key+" - "+value)
     counter += 1
  end
end


