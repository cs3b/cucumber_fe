class Kanban
  def initialize(features)
    @features = features
    @tags = Hash.new { |hash, key| hash[key] = [] }
    scan_tags
  end

  def tags(type)
    case type
      when :all
        @tags.values.flatten.sort
      else
        []
    end
  end

  private

  def scan_tags
    @features.each do |feature|
      feature.scenarios.each do |scenario|
        scenario.tags.each do |tag|
          group = Kanban.tag_group(tag)
          @tags[group].push tag
          @tags[group].uniq!
        end
      end
    end
  end


  class << self
    def tag_group(tag)
      case tag
        when /@[a-z]{2}\z/
          :author
        when /@m\d.{0,1}\z/
          :milestone
        when /@(spec|todo|wip|done|q_a|accepted)\z/
          :status
        else
          :module
      end
    end
  end

end