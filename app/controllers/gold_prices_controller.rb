class GoldPricesController < ApplicationController
  require 'httparty'

  def index
    response = HTTParty.get("https://www.goldapi.io/api/XAU/USD",
                            headers: { "x-access-token" => "goldapi-32brhvcslxghksqm-io", "Content-Type" => "application/json" })

    # Afficher la réponse complète pour le débogage
    Rails.logger.info "API Response: #{response.parsed_response.inspect}"

    if response.success?
      @api_response = response.parsed_response
      if @api_response["price"]
        @gold_price = @api_response["price"]
      else
        @error_message = "Price not found in the API response: #{@api_response.inspect}"
      end
    else
      @error_message = "Failed to fetch data from the API: #{response.code} - #{response.message}"
    end
  end
end
