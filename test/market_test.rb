require "minitest/autorun"
require "minitest/pride"
require "./lib/Market"

class MarketTest < MiniTest::Test

  def test_it_exists_with_attributes
    market = Market.new("South Pearl Street Farmers Market")
    #=> #<Market:0x00007fe134933e20...>

    assert_instance_of Market, market
  end

  def test_it_has_attributes
    market = Market.new("South Pearl Street Farmers Market")
    
    assert_equal "South Pearl Street Farmers Market", market.name
    assert_equal [], market.vendors
  end

end
