require 'json'
require 'rspec'

RSpec.describe "Giphy API Search" do
  def giphySearch(query, offset=0, limit=25)
    base_url = "https://api.giphy.com/v1/gifs/search"
    uri = URI.parse("#{base_url}?api_key=#{ENV["GIPHY_API_KEY"]}&q=#{query}&offset=#{offset}&limit=#{limit}")
    print uri
    Net::HTTP.get_response(uri)
  end

  describe "Searching for 'cat'" do
    before(:context) do
      @response = giphySearch("cat")
    end

    it "successfully returns a 200 OK response" do
      expect(@response.code).to eq("200")
    end

    it "returns a JSON response with data" do
      json_response = JSON.parse(@response.body)
      expect(json_response).to have_key("data")
      expect(json_response["data"]).to be_an(Array)
      expect(json_response["data"]).not_to be_empty
    end

    it "each item in the data array has a 'type' of 'gif'" do
      json_response = JSON.parse(@response.body)
      data = json_response["data"]
      data.each do |item|
        expect(item["type"]).to eq("gif")
      end
    end
  end
end