class Worksheet < Struct.new(:worksheet, :files, :tags)

  def fill_worksheet
    @row =1     
    write_header
    files.each do |file|
      feature_starts
      write_feature_info(file) if feature_pass_filter(file)
      file.scenarios.each do |scenario|
        write_scenario_info(scenario) if scenario_pass_filter(scenario)
      end
      feature_ends
    end
  end

  private

  def write_header
    worksheet[1,1] = "feature"
    worksheet[1,2] = "scenario"
    worksheet[1,3] = "estimation"
    worksheet[1,4] = "tags"
    worksheet[2,1] = "=COUNTA(A3:A#{Document::DOC_ROW_LIMIT})/2"
    worksheet[2,2] = "=COUNTA(B3:B#{Document::DOC_ROW_LIMIT})"
    worksheet[2,3] = "=SUM(C3:C#{Document::DOC_ROW_LIMIT})"
    @row+=2
  end

  def write_feature_info(file)
    worksheet[@row,1] = file.feature.title
    #TODO remove dependency
    worksheet[@row+1,1] = file.relative_path_for(CucumberEditor.prefix)
    worksheet[@row,3] = file.feature.estimation
    worksheet[@row,4] = file.feature.tags.join(",")
    @row +=2
  end

  def feature_starts
    @row_feature_start = @row
  end

  def feature_ends
    worksheet[@row_feature_start,5] = "=SUM(C#{@row_feature_start+1}:C#{@row-1})"
  end

  def write_scenario_info(scenario)
    worksheet[@row,2] = scenario.title
    worksheet[@row,3] = scenario.estimation
    worksheet[@row,4] = scenario.tags.join(",")
    @row +=1
  end

  def scenario_pass_filter(scenario)
    !tags.collect {|tag| scenario.tags.include?(tag) }.include?(false)
  end

  def feature_pass_filter(file)
    !tags.collect {|tag| file.raw =~ %r{#{tag}} }.include?(nil)
  end
end