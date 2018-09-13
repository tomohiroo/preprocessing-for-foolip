require 'csv'
require 'json'
require 'faraday'

def get_categories categories
  categories.each do |c|
    @categories << [c["id"], c["name"], c["shortName"]]
    if !c["categories"].empty?
      get_categories c["categories"]
    end
  end
end

url = 'https://api.foursquare.com/v2/venues/categories'

conn = Faraday.new(url: url)
response = conn.get do |req|
  req.params[:client_id] = "ENSMXAOPXNEBDGR01HKSFAPKWAIEGXP3BQO5QRLEAS3WNQT5"
  req.params[:client_secret] = "1I0QEICEE3UOXPXR3V4RCWUK3K00QOLGFNLN3RPG501QVGKP"
  req.params[:v] = 20180323
  req.params[:locale] = "ja"
end

@categories = [["foursquare_id", "name", "short_name"], ["4d4b7105d754a06374d81259", "飲食店", "飲食店"]]
restaurant_categories = JSON.parse(response.body)["response"]["categories"][3]["categories"]
get_categories restaurant_categories

CSV.open("foursquare_category.csv", "w") do |csv|
  @categories.each do |c|
    csv << c
  end
end
