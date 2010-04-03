#tested
@m2a @ao
Feature: Users can view offers for specific products

  Background:
    Given I am on the homepage
    And there's group "Supplier"
    And there's group "Clinic" for "Supplier"
    When I follow "Register"
    And I fill in the following:
    |First name             |Jon           |
    |Last name              |Lajoie        |
    |Email                  |jon@lajoie.ca |
    |Password               |topsecret     |
    |Password confirmation  |topsecret     |
    And I press "Create"
    Then I should see "Your account has been created"
    When user "jon@lajoie.ca" has activated account
    And I sign in as "jon@lajoie.ca/topsecret"
    Then I should see "Login successful"
    When I follow "Dashboard"
    And I fill in "organization_name" with "Jon's Clinic"
    And I press "Find / Create"
    And I press "Create Organization"

  @pending @m2b
  Scenario: Offer should be Specific to a product/model/manufacturer
    # the functionality is there but
    # we can't test it because its done using AJAX

  @pending @m2b
  Scenario: Save in My Fav Offers

  @pending @m2b
  Scenario: Clinic should be able to sell only to customers (Clinic Offers will have only public visibility (default and not editable).)
    # can't be implemented because there is no other roles yet in the system