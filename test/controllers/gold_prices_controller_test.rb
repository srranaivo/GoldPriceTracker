require "test_helper"

class GoldPricesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gold_prices_index_url
    assert_response :success
  end
end
