Feature: User Logout
  As a signed-in user
  I want to log out from the Settings screen
  So that nobody else can use my account on this device

  Background:
    Given the user is logged in with the test account
    And the user navigates to the Settings tab

  Scenario: Logging out returns to the Login screen
    When the user taps the logout option
    Then the logout confirmation "Are you sure you want to logout?" is shown
    When the user confirms the logout
    Then the user should see the Login screen

  Scenario: Cancelling logout keeps the user signed in
    When the user taps the logout option
    And the user cancels the logout
    Then the "settings_table_view" element is displayed

  Scenario: Logged-out user stays logged out after relaunching the app
    When the user taps the logout option
    And the user confirms the logout
    Then the user should see the Login screen
    When the app is restarted
    Then the user should see the Login screen
