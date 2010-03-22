class Worksheet < Struct.new(:worksheet, :files, :tags)

  def fill_worksheet
    @row =1     
    write_header
    files.each do |file|
      write_feature_info(file)
      file.scenarios.each do |scenario|
        write_scenario_info(scenario) if scenario_pass_filter(scenario)
      end
    end
  end

  private

  def write_header
    worksheet[1,1] = "feature"
    worksheet[1,2] = "scenario"
    worksheet[1,3] = "estimation"
    worksheet[1,4] = "tags"
    @row+=1
  end

  def write_feature_info(file)
    worksheet[@row,1] = file.feature.title
    worksheet[@row+1,2] = file.path
    worksheet[@row,3] = file.feature.estimation
    worksheet[@row,4] = file.feature.tags.join(",")
    @row +=2
  end

  def write_scenario_info(scenario)
    worksheet[@row,2] = scenario.title
    worksheet[@row,3] = scenario.estimation
    worksheet[@row,4] = scenario.tags.join(",")
    @row +=1
  end

  def scenario_pass_filter(scenario)
    # TODO support more tags
    scenario.tags.include?( tags.first )
  end
end