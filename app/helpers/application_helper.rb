module ApplicationHelper
  
  require 'uri'

  def valid_url?(url)
    url = URI.parse(url) 
    url = url && !url.host.nil?
  rescue URI::InvalidURIError
    false
  end 
end
