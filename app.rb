require "sinatra"
require "sinatra/reloader"
require "httparty"
def view(template); erb template.to_sym; end

get "/" do
  ### Get the weather
  # Evanston, Kellogg Global Hub... replace with a different location if you want
  lat = 42.0574063
  long = -87.6722787

  units = "imperial" # or metric, whatever you like
  key = "be5864316f7aa735ea6bcc2c03bcb750" # replace this with your real OpenWeather API key

  # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{key}"

  # make the call
  @forecast = HTTParty.get(url).parsed_response.to_hash

  @current_weather = "#{@forecast["current"]["temp"]} degrees and #{@forecast["current"]["weather"][0]["description"]}"
  @extended_forecast = []
  i = 0
  for day in @forecast["daily"]
    @extended_forecast << ["#{i}", "#{day["weather"][0]["main"]} with a high of #{day["temp"]["max"]} and a low of #{day["temp"]["min"]}"]
    i = i + 1
  end 

  ### Get the news
  url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=f663fbf56ba5479488d3d40b0fc58755"
  @news = HTTParty.get(url).parsed_response.to_hash

  @topnews=[]
  for article in @news["articles"]
    @topnews << ["#{article["title"]}","#{article["url"]}","#{article["content"]}"]
  end 

  view "news"  
end
