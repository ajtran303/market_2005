require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
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

  def test_it_exists
    market = Market.new("South Pearl Street Farmers Market")
    #=> #<Market:0x00007fe134933e20...>

    assert_instance_of Market, market
  end

  def test_it_has_attributes
    Market.stubs(:get_date).returns("24/02/2020")

    market = Market.new("South Pearl Street Farmers Market")

    assert_equal "South Pearl Street Farmers Market", market.name
    assert_equal [], market.vendors
    assert_equal "24/02/2020", market.date
  end

  def test_it_can_get_todays_date
    expected_date = Date.today.strftime("%d/%m/%y")

    assert_equal expected_date, Market.get_date
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

  def test_it_can_get_total_inventory
    @vendor3.stock(@item3, 10)

    market = Market.new("South Pearl Street Farmers Market")

    market.add_vendor(@vendor1)
    market.add_vendor(@vendor2)
    market.add_vendor(@vendor3)

    expected_inventory =
      {
      @item1 => {
        quantity: 100,
        vendors: [@vendor1, @vendor3]
      },
      @item2 => {
        quantity: 7,
        vendors: [@vendor1]
      },
      @item4 => {
        quantity: 50,
        vendors: [@vendor2]
      },
      @item3 => {
        quantity: 35,
        vendors: [@vendor2, @vendor3]
      },
    }
    assert_equal expected_inventory, market.total_inventory
  end

  def test_it_can_sell
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    item2 = Item.new({name: 'Tomato', price: '$0.50'})
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    item5 = Item.new({name: 'Onion', price: '$0.25'})

    vendor1 = Vendor.new("Rocky Mountain Fresh")
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)

    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)

    vendor3 = Vendor.new("Palisade Peach Shack")
    vendor3.stock(item1, 65)

    market = Market.new("South Pearl Street Farmers Market")
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)

    assert_equal false, market.sell(item1, 200) # 100 item1's
    assert_equal false, market.sell(item5, 1) # 0 item5's

    assert_equal true, market.sell(item4, 5) # 50 item4's - sell 5
    assert_equal 45, vendor2.check_stock(item4) # now 45

    assert_equal true, market.sell(item1, 40) # 100 item1's - sell 40
    assert_equal 0, vendor1.check_stock(item1) # vendor1 sells first 35
    assert_equal 60, vendor3.check_stock(item1) # vendor3 sells last 5
  end

end


=begin
Add a method to your Market class called `sell`
that takes an item and a quantity as arguments.
There are two possible outcomes of the `sell`
method:

1. If the Market does not have enough of the
item in stock to satisfy the given quantity,
this method should return `false`.

2. If the Market's has enough of the item in
stock to satisfy the given quantity, this
method should return `true`. Additionally,
this method should reduce the stock of the
Vendors. It should look through the Vendors in
the order they were added and sell the item from
the first Vendor with that item in stock. If that
Vendor does not have enough stock to satisfy the
given quantity, the Vendor's entire stock of that
item will be depleted, and the remaining quantity
will be sold from the next vendor with that item
in stock. It will follow this pattern until the
entire quantity requested has been sold.

For example, suppose vendor1 has 35 `peaches` and vendor3 has 65 `peaches`, and vendor1 was added to the market first. If the method `sell(<ItemXXX, @name = 'Peach'...>, 40)` is called, the method should return `true`, vendor1's new stock of `peaches` should be 0, and vendor3's new stock of `peaches` should be 60.

=end
