Feature: Manage Pages
  In order to manage Pages
  As a guest
  I want to list, create, update, and delete pages
  
  Background:
    Given a api_key
        
  Scenario: List Pages
    Given I have pages titled index, about
    When I go to the list of pages
    Then I should see 2 pages
    And I should see "index"
    And I should see "about"
    
  Scenario: Create Page 
    Given I have no pages
    When Submit a Page with "Hello World"
    Then I should see 1 page
    And I should see "Hello World"
    
  Scenario: Update Page
    Given I have page titled index
    When I Submit update Page with "Hello World"
    Then I should see "Hello World"
    
  Scenario: Delete Page
    Given I have page titled index
    When I Submit delete Page
    Then I should have no pages
