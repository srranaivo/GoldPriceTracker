class GoldPricesController < ApplicationController
  require 'httparty'

  def index
    response = HTTParty.get("https://metals-api.com/api/latest?access_key=r5aez8535k2h9ch78as69a53boi5td4v4lj1vzglt26l99j04h3c56i9b1dk&base=USD&symbols=XAU")

    # Afficher la réponse complète pour le débogage
    Rails.logger.info "API Response: #{response.parsed_response.inspect}"

    if response.success?
      if response.parsed_response["rates"] && response.parsed_response["rates"]["XAU"]
        @gold_price = response.parsed_response["rates"]["XAU"]
      else
        @error_message = "Rates not found in the API response: #{response.parsed_response}"
      end
    else
      @error_message = "Failed to fetch data from the API: #{response.code} - #{response.message}"
    end
  end
end
