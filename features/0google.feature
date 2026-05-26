Feature: As a BDD fanatic
         I want to start writing my tests
         so I learn more about automation

Scenario: Testing links on UCB page
  Given I browse to the UCB page
  When I see a link for the "SIAAn"
  And I see a link for the "LMS – UCB"
  And I see a link for the "Google Workspace"
  And I see text about working hours "Atención de lunes a viernes de 08:30 a 16:00"
  And I see a direct link for "Calendario Académico"
  Then all links are visible so I close the page

Scenario: Test Houston Dynamo Website        
  Given I am on the Dynamo homepage
  When I press the "Club" link
  And I press the "Front Office" link
  Then I see that information show below
  |Ted Segal     |Majority Owner & Chairman|
  |Lyle Ayes     |Owner/Vice Chairman      |
  |James Harden  |Investor/Owner           |
  |Tim Howard    |Investor/Owner           |

