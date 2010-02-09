class Documentation::FeaturesController < ApplicationController

  before_filter :set_scope, :dirs_to_select

  def index
    CucumberEditor.prefix= @scope
    CucumberEditor.scan
  end

  def new

  end

  def create
    if file_params = parse_params(params[:feature_name])
      @file = CucumberEditor::File.update_or_create(file_params)
      redirect_to edit_documentation_feature_path(Base64.encode64(@file.relative_path_for(@dir)))
    elsif @file
      link = edit_documentation_feature_path(Base64.encode64(@file.relative_path_for(@dir)))
      flash[:error] = "Feature already exist, you can follow <a href='#{link}'>this link</a>}".html_safe!
      redirect_to :action => :new, :feature_name => params[:feature_name],
                  :scope => params[:scope]
    else
      flash[:error] = "Feature name is to short"
      redirect_to :action => :new, :feature_name => params[:feature_name],
                  :scope => params[:scope]
    end
  end

  def edit
    @file = CucumberEditor::File.new(path)
  end

  def show
    file = CucumberEditor::File.new(path)
    render :inline => "<pre>#{file.raw}</pre>"
  end

  def update
    file_params = params[:file]
    file_params[:path] = path
    file = CucumberEditor::File.update_or_create(file_params)
    redirect_to edit_documentation_feature_path(params[:id])
  end

  private

  def set_scope
    @dir = Rails.root.join('features')
    @scope = params[:scope] ? @dir.join(params[:scope]) : @dir
  end

  def dirs_to_select
    permited_dirs = %w(_mc _step_definitions support . ..)
    @scope_options = [""] + Dir.entries(@dir) - permited_dirs
  end

  def path
    @dir.to_s + Base64.decode64(params[:id])
  end

  def parse_params(f_name)
    f_name.gsub!(/^.*Feature:\s*/, '')
    filename = f_name.downcase.gsub(/\s/, "_")+".feature"
    @path = @scope.join filename
    if f_name.blank? or f_name.length < 5 
      false
    elsif File.exist? @path
      @file = CucumberEditor::File.new(@path)
      false
    else
      file_params = {
              :feature => "Feature: #{f_name}",
              :path => @path,
              :scenarios => []
      }
    end
  end

end