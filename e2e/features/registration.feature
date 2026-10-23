Feature: New User Registration
  As a new user
  I want to create an account from the login screen
  So that I can start saving my reminders

  Background:
    Given the user is on the Splash screen
    When the app finishes loading
    Then the user should see the Login screen

  Scenario: Register a new user with valid details
    When I open the registration screen
    Then the "registration_title_label" element is displayed
    And the register button is disabled
    When I enter "Test User" into the registration "name" field
    And I enter "testingone+<timestamp>@gmail.com" into the registration "email" field
    And I enter "Password123!" into the registration "password" field
    And I enter "Password123!" into the registration "repeat password" field
    Then the register button is enabled
    When I tap the register button
    Then I should be redirected to the Home screen dashboard
