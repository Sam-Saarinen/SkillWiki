require "unirest"

module WebScraper
  
  # Contextual web search API key
  Contextual_Web_Search_Key = "a622737202msh335c1e3d5041eb0p18cc15jsn50e25ce06e9e"
  
  # Algolia 
  # Faroo Web Search
  
  # Get top 5 search results for topic name and save to resource table.
  # TODO: When user creates topic, give list of possible resources to check off for addition to the table.
  def scrape_resources(topic)
    
    #The query parameters: (update according to your search query)
    q = "#{topic.name}"; #the search query
    pageNumber = 1 #the number of requested page
    pageSize = 5 #the size of a page
    autoCorrect = true #autoCorrectspelling
    safeSearch = true #filter results for adult content
    
    response = Unirest.get "https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/WebSearchAPI?q=#{q}&pageNumber=#{pageNumber}&pageSize=#{pageSize}&autoCorrect=#{autoCorrect}&safeSearch=#{safeSearch}",
      headers:{
        "X-RapidAPI-Key" => Contextual_Web_Search_Key
      }
      
    resources = []
    
    #Go over each resulting item
    response.body["value"].each do |webPage|
  
      #Get the web page metadata  
      url = webPage["url"]
      
      # Removes html tags from title and titleizes the string.
      title = ActionView::Base.full_sanitizer.sanitize(webPage["title"])
      title = title.titleize
      
      # User with id of 2 is the web scraper.
      content = { link: url, video: "", text: "" }
      res = Resource.new(name: title, content: content.to_json, topic_id: topic.id, user_id: 2) 
      if res.save
        resources << res 
      else 
        raise "Resource could not be saved. Ensure resource is valid."
      end 
    end 
    resources 
  end 
  
end 