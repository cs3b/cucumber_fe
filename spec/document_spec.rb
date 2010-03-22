#require 'spec_helper'
require 'lib/document'
describe Document do
  before(:all) do
    @document = Document.new
  end
  it "should create new worksheet" do
    @document.new_worksheet('@m2b')
  end
end