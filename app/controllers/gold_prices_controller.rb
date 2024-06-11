class GoldPricesController < ApplicationController
  require 'httparty'

  def index
    response = HTTParty.get("https://openexchangerates.org/api/latest.json?app_id=3f8b856ad62245ea8370fd5d9760c351")

    # Afficher la réponse complète pour le débogage
    Rails.logger.info "API Response: #{response.parsed_response.inspect}"

    if response.success?
      # L'API openexchangerates ne fournit pas directement le prix de l'or, mais on peut utiliser le taux de XAU par rapport à l'USD
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
