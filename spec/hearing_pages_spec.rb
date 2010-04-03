require 'cucumber_editor'
require 'worksheet'
require 'document'

describe "HearingPages features" do
  before(:all) do
    TAGS = ['@m2c']
    CucumberEditor.prefix = '/home/mc/projects/earworks/hp/features'
    CucumberEditor.scan
    @document = Document.new
    @worksheet = @document.new_worksheet(TAGS.join(" and "))
  end

  it "should create doc for estimating purpose" do
    worksheet = Worksheet.new(@worksheet, CucumberEditor.files, TAGS)
    worksheet.fill_worksheet
    @document.save
  end
end
