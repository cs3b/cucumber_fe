require 'lib/cucumber_editor'
require 'lib/kanban'

describe Kanban do
  before(:all) do
    CucumberEditor.prefix = 'features_kanban'
    CucumberEditor.scan
    @kanban = Kanban.new(CucumberEditor.files)
  end

  context "TAG GROUPING" do
    {
            # two or three small letters
            :developer => %w(@mc @ao @ak @tb @rj @rb @bk),
            # m + number + optional letter
            :milestone => %w(@m1 @m2 @m2a @m0),
            # status start from _ and have at least 2 alphanumeric characters
            :status => %w(@_spec @_todo @_wip @_done @_qa @_accepted),
            # single digit
            :complexity => %w(@1 @3 @7),
            # everything else
            :module => %w(@user @group @product_review )
    }.each_pair do |group_name, tags|
      tags.each do |tag|
        it "should recognize tag #{tag} as #{group_name}" do
          Kanban.tag_group(tag).should == group_name
        end
      end
    end
  end

  it "should have all tags detected" do
    @kanban.tags(:all).should ==
            %w( @m2a @m2b @mc @tb @3 @1 @product_review @_accepted @added @_done @pending @_qa @javascript @_wip ).sort
  end

  it "should return array of tags responsible for status" do
    @kanban.tags(:status).should == %w(@_done @_qa @_accepted @_wip).sort
  end
  it "should return array of tags responsible for milestone" do
    @kanban.tags(:milestone).should == %w( @m2a @m2b )
  end
  it "should return array of tags responsible for user ownership" do
    @kanban.tags(:developer).should == %w( @mc @tb )
  end
  it "should return array of tags responsible for module" do
    @kanban.tags(:module).should == %w( @product_review @added @pending @javascript ).sort
  end

  ## powinien zglosic blad jesli ktorys scenariusz ma dwa tagi oznaczajace status i wlozyc scenariusz
  ## do wszystkich grup !! not sure

  # Do we really want skip some tags ?
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