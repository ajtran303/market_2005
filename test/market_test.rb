require "minitest/autorun"
require "minitest/pride"
require "./lib/market"
require "./lib/item"
require "./lib/vendor"

class MarketTest < MiniTest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    #=> #<Item:0x007f9c56740d48...>
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    #=> #<Item:0x007f9c565c0ce8...>
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    #=> #<Item:0x007f9c562a5f18...>
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    #=> #<Item:0x007f9c56343038...>

    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    #=> #<Vendor:0x00007fe1348a1160...>
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)

    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    #=> #<Vendor:0x00007fe1349bed40...>
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)

    @vendor3 = Vendor.new("Palisade Peach Shack")
    #=> #<Vendor:0x00007fe134910650...>
    @vendor3.stock(@item1, 65)
  end

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

  def test_it_can_add_vendors
    market = Market.new("South Pearl Street Farmers Market")

    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor2, @vendor3], market.vendors
  end

  def test_it_knows_vendor_names
    market = Market.new("South Pearl Street Farmers Market")

    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)

    expected_names =
      ["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"]
    assert_equal expected_names, market.vendor_names
  end

  def test_it_knows_vendors_that_sell_item
    market = Market.new("South Pearl Street Farmers Market")

    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor3], market.vendors_that_sell(@item1)
    assert_equal [@vendor2], market.vendors_that_sell(@item4)
  end

  def test_it_can_get_sorted_item_list
    @vendor3.stock(@item3, 10)

    market = Market.new("South Pearl Street Farmers Market")

    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)

    expected_items =
      ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"]

    assert_equal expected_items, market.sorted_item_list
  end

  def test_it_knows_overstocked_items
    @vendor3.stock(@item3, 10)

    market = Market.new("South Pearl Street Farmers Market")

    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)

    assert_equal [@item1], market.overstocked_items
  end

end
