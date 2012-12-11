Feature: Signing in

  Scenario: Unsuccessful signin
    Given a user visits the signin page
    When he submits invalid signin information
    Then he should see an error message

  Scenario: Succesfful signin
  	Given a user visits the signin page
  	And the user has an account
  	And he submits valid signin information
  	Then he should see his profile page
  	And he should see the signout link