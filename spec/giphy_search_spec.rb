require 'json'
require 'rspec'

RSpec.describe "Giphy API Search" do
  def giphySearch(query, offset=0, limit=25, api_key=ENV["GIPHY_API_KEY"])
    base_url = "https://api.giphy.com/v1/gifs/search"
    uri = URI.parse("#{base_url}?api_key=#{api_key}&q=#{query}&offset=#{offset}&limit=#{limit}")
    Net::HTTP.get_response(uri)
  end

  describe "Invalid API Key" do
    it "returns a 401 Unauthorized response" do
      response = giphySearch("cat", 0, 25, "INVALID_API_KEY")
      expect(response.code).to eq("401")
    end
  end

  describe "Test Invalid Offset" do
    it "returns a empty data" do
      response = giphySearch("cat", -10, 25)
      expect(response.code).to eq("200")
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("data")
      expect(json_response["data"]).to be_empty
    end
  end

  describe "Test Invalid limit" do
    it "returns a empty data" do
      response = giphySearch("cat", 0, -25)
      expect(response.code).to eq("200")
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key("data")
      expect(json_response["data"]).to be_empty
    end
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
  
    it "paginates results correctly with offset and limit" do
      json_response = JSON.parse(@response.body)
      pagination = json_response["pagination"]
      expect(pagination).to have_key("total_count")
      expect(pagination).to have_key("count")
      expect(pagination).to have_key("offset")  
      expect(pagination["count"]).to eq(25)
      expect(pagination["offset"]).to eq(0)
    end
  end
end