module ApplicationHelper
  
  require 'uri'
  
  ProgressMessages = { 
    doingWellThreshold: 2.5,
    needHelp: " is finding the recommended resources unhelpful.",
    doingWell: " is doing well!",
    notStarted: " has not started the assignment yet."
  }
  
  ScoreMessages = {
    "right": "<span style='color: green;'>Correct</span>",
    "partial": "<span style='color: orange;'>Partial Credit</span>",
    "wrong": "<span style='color: red;'>Incorrect</span>",
    "not graded": "<span>Not graded<span>"
  }
  
  WebScraperOptions = {
    numSearchResults: 10
  }

  def valid_url?(url)
    # TODO: Check if 'https://' has been added and append to front if needed.
    # If not a valid url, prepend https if not already and check again
    url = URI.parse(url) 
    url = url && !url.host.nil?
    rescue URI::InvalidURIError
      false
  end 
  
end
