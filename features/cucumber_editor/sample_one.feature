@m2a @mc @product_review
Feature: Read a review

  Background: I am not logged in
    Given product "Some Product that can be reviewed" is already created
    And product with name "Some Product that can be reviewed" is allowed to be reviewed by consumers

# 0.90

  @1 @javascript
  Scenario: I can browse the most helpful reviews on the product page (with a View All... button under the list) with the most recent on top
    Then I should see "The most helpful review" within "#expert_review"
    And I should see product rating within "#expert_review"

# 0.90

  @pending @mc @m2b
  Scenario: I click the View All and I can see a list of all the reviews for that product.
    Given I should see "Read All User Reviews"

# 0.90

  @added @3
  Scenario: I can read full user review
    When I follow "Read the full review >" within "#positiv_review"
    Then I should see "Very good product"