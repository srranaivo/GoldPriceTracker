class GoldPricesController < ApplicationController
  require 'httparty'

  def index
  #   response = HTTParty.get("https://www.goldapi.io/api/XAU/USD",
  #                           headers: { "x-access-token" => "goldapi-32brhvcslxghksqm-io", "Content-Type" => "application/json" })

  #   # Afficher la réponse complète pour le débogage
  #   Rails.logger.info "API Response: #{response.parsed_response.inspect}"

  #   if response.success?
  #     @api_response = response.parsed_response
  #     if @api_response["price"]
  #       @gold_price = @api_response["price"]
  #     else
  #       @error_message = "Price not found in the API response: #{@api_response.inspect}"
  #     end
  #   else
  #     @error_message = "Failed to fetch data from the API: #{response.code} - #{response.message}"
  #   end
  # end

    # Utiliser l'API GoldAPI pour obtenir le prix actuel de l'or
    goldapi_response = HTTParty.get("https://www.goldapi.io/api/XAU/USD",
                                    headers: { "x-access-token" => "goldapi-32brhvcslxghksqm-io", "Content-Type" => "application/json" })

    Rails.logger.info "GoldAPI Response: #{goldapi_response.parsed_response.inspect}"

    if goldapi_response.success?
      @api_response = goldapi_response.parsed_response
      if @api_response["price"]
        @gold_price = @api_response["price"]
      else
        @error_message = "Price not found in the GoldAPI response: #{@api_response.inspect}"
      end
    else
      @error_message = "Failed to fetch current gold price from GoldAPI: #{goldapi_response.code} - #{goldapi_response.message}"
    end

    # Utiliser l'API Open Exchange Rates pour obtenir le prix de l'or de la veille
    api_key = "3f8b856ad62245ea8370fd5d9760c351"
    yesterday = (Time.now - 1.day).strftime("%Y-%m-%d")
    openexchangerates_response = HTTParty.get("https://openexchangerates.org/api/historical/#{yesterday}.json?app_id=#{api_key}&symbols=XAU")

    Rails.logger.info "OpenExchangeRates Response: #{openexchangerates_response.parsed_response.inspect}"

    if openexchangerates_response.success?
      rates = openexchangerates_response.parsed_response["rates"]
      if rates && rates["XAU"]
        @previous_gold_price = (1 / rates["XAU"]).round(2) # Conversion en USD par once
      else
        @error_message = "Gold price for XAU not found in the Open Exchange Rates response: #{openexchangerates_response.inspect}"
        @previous_gold_price = 0.0
      end
    else
      @error_message = "Failed to fetch historical gold price from Open Exchange Rates: #{openexchangerates_response.code} - #{openexchangerates_response.message}"
    end

# # Définir l'orientation en fonction de la comparaison
#   @arrow_orientation = @gold_price > @previous_gold_price ? 'up' : 'down'

  end
end
