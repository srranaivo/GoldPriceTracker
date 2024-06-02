class GoldPricesController < ApplicationController
  require 'httparty'

  def index
    response = HTTParty.get("https://metals-api.com/api/latest?access_key=r5aez8535k2h9ch78as69a53boi5td4v4lj1vzglt26l99j04h3c56i9b1dk&base=USD&symbols=XAU")
    @gold_price = response.parsed_response["rates"]["XAU"]
  end
end
