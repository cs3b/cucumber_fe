require 'singleton'
class CucumberEditor
  include Singleton
  @@prefix = ''
  @@files = []

  class << self
    def scan
      @@files = []
      Dir.glob("#{prefix}/**/*.feature").collect { |full_path|
        files << File.new(full_path)
      }
    end

    def files
      @@files
    end

    def prefix
      @@prefix
    end

    def prefix=(prefix)
      @@prefix = prefix
    end

    def count
      files.size
    end
    #TODO config
    def pull
      `cd #{prefix} && git pull`
    end

    def commit(msg)
      msg = `cd #{prefix} && git add .`
      msg << `cd #{prefix} && git commit -m "#{msg}"`
      msg
    end

    def push
      `cd #{prefix} && git push origin next`
    end

    def changes
      `cd #{prefix} && git diff origin/next .`
    end
  end

  class File < Struct.new(:path)

    attr_accessor :parsed
    @parsed = false
    @raw = nil

    # {:path => $raw, :feature => $raw, :scenarios => [$raw]}
    def self.update_or_create(params)
      file = new(params[:path])
      file.add_feature Feature.new(params[:feature])
      file.add_background Background.new(params[:background]) if params.has_key?(:background)
      params[:scenarios].each do |scenario|
        file.add_scenario Scenario.new(scenario)
      end if params[:scenarios]
      file.save
      file
    end

    def feature
      parse
      @feature
    end

    def scenarios
      parse
      @scenarios
    end

    def background
      parse
      @background
    end

    def raw
      @raw ||= read_from_file
    end

    def raw=(body)
      @raw = body
    end

    def save
      write_to_file
    end

    def add_scenario(scenario)
      @scenarios ||= []
      @scenarios << scenario
    end

    def add_feature(feature)
      @feature = feature
    end

    def add_background(background)
      @background = background
    end

    def title
      feature ? feature.title : ::File.basename(path, 'feature').humanize
    end

    def relative_path_for(prefix)
      path.to_s.gsub(prefix, '')
    end

    private

    def read_from_file
      ::File.open(path, 'r') do |file|
        file.read
      end
    end

    def write_to_file
      compile_raw
      ::File.open(path, 'w') do |file|
        file.write raw
      end
    end

    def compile_raw

      @parsed = true
      @raw = if @feature
        @feature.raw
      elsif @path
        "Feature: #{title}"
      else
        "Feature: <...>"
      end
      @raw << "\n\n"
      @raw << @background.raw << "\n\n" if @background
      @raw << if @scenarios
        @scenarios.map(&:raw).join("\n\n") << "\n"
      else
        "Scenario: <...>\n\n"
        
      end
    end

    private

    def parse
      unless parsed
        buffer = Buffer.new(self)
        raw.split("\n").each do |line|

          case line
            when /^(\s)*$/
              case buffer.klass
                when nil
                  # do nothing
                else
                  if buffer.flag
                     buffer.push line
                  else
                    buffer.flush
                  end
              end
            when /^(\s)*Feature:.*/
              buffer.push line
              buffer.klass = Feature
            when /^(\s)*Scenario Outline:.*/
              buffer.push line
              buffer.klass = ScenarioOutline
              buffer.flag = true
            when /^(\s)*Examples:.*/
              buffer.push line
              buffer.flag = false
            when /^(\s)*Scenario:.*/
              buffer.push line
              buffer.klass = Scenario
            when /^(\s)*Background:.*/
              buffer.push line
              buffer.klass = Background
            else
              buffer.push line
          end
        end
        buffer.flush unless buffer.empty?
      end
      self.parsed = true
    end
  end


  class Buffer < Struct.new(:file, :klass, :flag)

    def push(line)
      @lines ||= []
      @lines << line
    end

    def flush
      begin
        object = klass.new(raw)
        object.attach_to_file(file)
      rescue => e
        Rails.logger.warn %Q{ #{e} \n\n\n
        File: #{file.inspect} \n Buffer:\n\n#{@lines.join('\n')}}
      end
      clear
    end

    def empty?
      @lines.nil? || @lines.empty?
    end

    private

    def raw
      @lines.join("\n")
    end

    def clear
      self.klass = nil
      @lines = []
    end
  end

  class Feature < Struct.new(:raw)

    def title
      raw.scan(/^.*Feature:.*/).first.gsub(/^.*Feature:\s*/, '')
    end

    def attach_to_file(file)
      @file = file
      file.add_feature self
    end


    def estimation
      tag = tags.detect {|tag| tag =~ /@(1|3)/ }
      tag ? tag.gsub('@','').to_i : nil
    end

    def tags
      raw.scan(/^\s*@.*$/).first.scan(/@[^\s]+/)
    end
  end

  class Scenario < Struct.new(:raw)

    def title
      raw.scan(/^.*Scenario:.*/).first.gsub(/^.*Scenario:\s*/, '')
    end

    def tags
      scan_tags
    end

    def estimation
      tag = tags.detect {|tag| tag =~ /@\d/ }
      tag ? tag.gsub('@','').to_i : nil
    end

    def css_classes
      tags.collect {|tag| tag.gsub(/@/, "")}
    end

    def attach_to_file(file)
      @file = file
      file.add_scenario self
    end

    private

    #TODO delagate tags from feature to feature
    def scan_tags
      feature_and_scenario = (feature_raw + raw)
      tags_lines = feature_and_scenario.scan(/^\s*@.*$/).join("\n")
      tags_lines.scan(/@[^\s]+/).uniq
    end

    def feature_raw
      @file.feature.raw
    end

  end

  class ScenarioOutline < Scenario
    def title
      raw.scan(/^.*Scenario Outline:.*/).first.gsub(/^.*Scenario Outline:\s*/, '')
    end
  end

  class Background < Struct.new(:raw)

    def title
      raw.scan(/^.*Background:.*/).first.gsub(/^.*Background:\s*/, '')
    end

    def attach_to_file(file)
      @file = file
      file.add_background self
    end
  end
end