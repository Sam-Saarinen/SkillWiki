module ApplicationHelper
  
  require 'uri'

  def valid_url?(url)
    # TODO: Check if 'https://' has been added and append to front if needed.
    # If not a valid url, prepend https if not already and check again
    url = URI.parse(url) 
    url = url && !url.host.nil?
    rescue URI::InvalidURIError
      false
  end 
end
