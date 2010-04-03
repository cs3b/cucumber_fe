class Documentation::FeaturesChangesController < Documentation::RootController
  before_filter :digest_authenticate
  before_filter :set_dir

  def show
    x = CucumberEditor.changes
    render :text => "<pre>#{x}</pre>".html_safe!
  end

  def commit
    response = CucumberEditor.commit(params[:msg] || Time.now.to_s)
    render :text => "<pre>#{response}</pre>"
  end

  def push
    response = CucumberEditor.push
    render :text => "<pre>#{response}</pre>"
  end

  def pull
    response = CucumberEditor.pull
    render :text => "<pre>#{response}</pre>"
  end

  private

  def set_dir
    @dir = Rails.root.join('features')
    CucumberEditor.prefix= @dir
  end

end