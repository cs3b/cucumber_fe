require 'lib/cucumber_editor'

describe "AO problematic parsing feature" do
  before(:all) do
    CucumberEditor.prefix = 'features/ao_bug'
    CucumberEditor.scan
    @file = CucumberEditor.files.first
  end

  it "should parse correctly tags for feature" do
    @file.feature.tags.should == %w(@m2a @ao)
  end

  it "should parse correctly tags for first scenario" do
    @file.scenarios.last.tags.should == %w(@m2a @ao @pending @m2b)
  end

end