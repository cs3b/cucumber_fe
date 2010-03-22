require 'cucumber_editor'
require 'worksheet'
require 'document'

class Feature < Struct.new(:path, :feature, :scenarios)
end

class Entity < Struct.new(:title)
end

describe Worksheet do
  before(:all) do
    CucumberEditor.prefix = 'features'
    CucumberEditor.scan
    @file1 = CucumberEditor.files.first
    CucumberEditor.prefix = 'features_kanban'
    CucumberEditor.scan
    @file2 = CucumberEditor.files.first

    @files = [
            @file1,
            @file2
            ]
    @document = Document.new
    @worksheet = @document.new_worksheet('@m2b')
  end

  it "should write info to spreadsheet" do
    worksheet = Worksheet.new(@worksheet, @files, ['@m2b'])
    worksheet.fill_worksheet
    @document.save
  end
end