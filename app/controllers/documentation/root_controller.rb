class Documentation::RootController < ActionController::Base
  layout 'cucumber_fe'
  def digest_authenticate
    unless session[:can_write_documentation]
      # Given this username, return the cleartext password (or nil if not found)
      session[:can_write_documentation] = authenticate_or_request_with_http_digest("HearingPages Documentation") do |username, password|
        username == 'hearingpages' && password == 'HearingPages.com'
      end
    end
  end

end