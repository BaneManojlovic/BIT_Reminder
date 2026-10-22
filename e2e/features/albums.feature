# Ignored until the Albums identifiers are in the app and the test user has an album with a photo.
@ignore
Feature: Albums and Photo Management Flow
  As a logged-in user
  I want to browse my photo albums and look at individual images
  So that I can view my saved reminders media

  Background:
    Given the user is logged into the application
    And the user navigates to the Albums tab
    Then the "albums_table_view" element should be visible

  Scenario: Browse Album and View Full Screen Image
    When the user selects the album at index "0"
    Then the "albums_collection_view_grid" element should be visible
    When the user selects the photo item at index "0"
    Then the "albums_full_image_viewer" element should be visible

  Scenario: Return Back to Album Gallery View
    Given the user is looking at a full screen image view
    When the user taps the back navigation button
    Then the gallery grid canvas "albums_collection_view_grid" should be displayed again
