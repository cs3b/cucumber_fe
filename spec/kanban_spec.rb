require 'lib/cucumber_editor'
require 'lib/kanban'

describe Kanban do
  before(:all) do
    CucumberEditor.prefix = 'features'
    CucumberEditor.scan
    @kanban = Kanban.new(CucumberEditor.files)
  end

  it "should have all tags detected" do
    @kanban.tags(:all).should == %w( @added @3 @pending @mc @m2a @product_review )
  end
  
  it "should return array of tags responsible for status" do
    pending
    @kanban.tags(:status).should == %w(@_spec @_todo @_done @_qa @_accepted)
  end
  it "should return array of tags responsible for milestone" do
    pending
    @kanban.tags(:milestone).should == %w( ... )
  end
  it "should return array of tags responsible for user ownership" do
    pending
    @kanban.tags(:user).should == %w( ... )
  end
  it "should return array of tags responsible for module" do
    pending
    @kanban.tags(:module).should == %w( ... )
  end

  ## powinien zglosic blad jesli ktorys scenariusz ma dwa tagi oznaczajace status i wlozyc scenariusz
  ## do wszystkich grup

  it "should have array of tags that should be skipped in filters" do
    pending
    @kanban.tags(:skip).should be_instance_of(Array)
  end

  context "GROUP SCENARIO by" do
    it "spec should be 2" do
      pending
      @kanban.scenarios(:spec).size.should == 2
    end
    it "todo should be 3" do
      pending
      @kanban.scenarios(:todo).size.should == 3
    end
    it "done should be 1" do
      pending
      @kanban.scenarios(:done).size.should == 1
    end
    it "qa should be 0" do
      pending
      @kanban.scenarios(:qa).size.should == 3
    end
    it "accepted should be 5" do
      pending
      @kanban.scenarios(:accepted).size.should == 3
    end
  end

end