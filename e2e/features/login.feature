Feature: User Login Flow
  As a returning user
  I want to securely log in to the application
  So that I can access my saved reminders

  Background:
    Given the user is on the Splash screen
    When the app finishes loading
    Then the user should see the Login screen

  Scenario: Login screen shows its main structural elements
    Then the "login_email_input" element is displayed
    And the "login_password_input" element is displayed
    And the "login_register_button" element is displayed
    And the "login_reset_password_button" element is displayed
    And the login button is disabled

  Scenario: Successful Login with Valid Credentials
    When I enter "testuser@example.com" into the email field
    And I enter "Password123!" into the password field
    And I tap the submit button
    Then I should be redirected to the Home screen dashboard

  Scenario: Validation Error with Invalid Email
    When I enter "invalid-email" into the email field
    And I tap the submit button
    Then I should see the email error label with text "Email is in invalid format"
