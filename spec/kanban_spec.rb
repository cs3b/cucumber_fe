require 'lib/cucumber_editor'
require 'lib/kanban'

describe Kanban do

  it "should have all tags detected" do
    pending
    Kanban.tags(:all).should == %w( .... )
  end
  it "should return array of tags responsible for status" do
    Kanban.tags(:status).should == %w(@_spec @_todo @_done @_qa @_accepted)
  end
  it "should return array of tags responsible for milestone" do
    pending
    Kanban.tags(:milestone).should == %w( ... )
  end
  it "should return array of tags responsible for user ownership" do
    pending
    Kanban.tags(:user).should == %w( ... )
  end
  it "should return array of tags responsible for module" do
    pending
    Kanban.tags(:module).should == %w( ... )
  end

  ## powinien zglosic blad jesli ktorys scenariusz ma dwa tagi oznaczajace status i wlozyc scenariusz
  ## do wszystkich grup

  it "should have array of tags that should be skipped in filters" do
    Kanban.tags(:skip).should be_instance_of(Array)
  end

  context "GROUP SCENARIO by" do
    it "spec should be 2" do
      Kanban.scenarios(:spec).size.should == 2
    end
    it "todo should be 3" do
      Kanban.scenarios(:todo).size.should == 3
    end
    it "done should be 1" do
      Kanban.scenarios(:done).size.should == 1
    end
    it "qa should be 0" do
      Kanban.scenarios(:qa).size.should == 3
    end
    it "accepted should be 5" do
      Kanban.scenarios(:accepted).size.should == 3
    end
  end

end