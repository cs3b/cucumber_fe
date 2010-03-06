require 'lib/cucumber_editor'
describe CucumberEditor do
  before(:all) do
    CucumberEditor.prefix = 'features'
    CucumberEditor.scan
    @file = CucumberEditor.files.first
  end

  it "should find two files" do
    CucumberEditor.files.size.should == 1
  end

  context "FEATURE" do
    it "should scan correctly" do
      @file.feature.raw.should == %Q{@m2a @mc @product_review
Feature: Read a review}
    end
  end

  context "BACKGROUND" do
    it "should scan correctly" do
      @file.background.raw.should == %Q{  Background: I am not logged in
    Given product "Some Product that can be reviewed" is already created
    And product with name "Some Product that can be reviewed" is allowed to be reviewed by consumers}
    end
  end

  context "SCENARIO" do
    context "should scan correctly" do
      it "first" do
        @file.scenarios.first.raw.should == %Q{# 0.90
  @1 @javascript
  Scenario: I can browse the most helpful reviews on the product page (with a View All... button under the list) with the most recent on top
    Then I should see "The most helpful review" within "#expert_review"
    And I should see product rating within "#expert_review"}
      end
      it "second" do
        @file.scenarios[1].raw.should == %Q{# 0.90
  @pending @mc
  Scenario: I click the View All and I can see a list of all the reviews for that product.
    Given I should see "Read All User Reviews"}
      end
      it "last" do
        @file.scenarios.last.raw.should == %Q{# 0.90
  @added @3
  Scenario: I can read full user review
    When I follow "Read the full review >" within "#positiv_review"
    Then I should see "Very good product"}
      end
    end
  end

  context "TAGS" do
    it "first scenario should have 5 tags" do
      scenario = @file.scenarios.first
      scenario.tags.should == %w(@m2a @mc @product_review @1 @javascript)
    end
    it "second scenario should have 4 tags" do
      scenario = @file.scenarios[1]
      scenario.tags.should == %w(@m2a @mc @product_review @pending)
    end
  end
end