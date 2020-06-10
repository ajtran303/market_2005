require "minitest/autorun"
require "minitest/pride"
require "./lib/vendor"
require "./lib/item"

class VendorTest < MiniTest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    #=> #<Item:0x007f9c56740d48...>

    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    #=> #<Item:0x007f9c565c0ce8...>
  end

  def test_it_exists_with_attributes
    vendor = Vendor.new("Rocky Mountain Fresh")
    #=> #<Vendor:0x00007f85683152f0...>

    assert_instance_of Vendor, vendor
  end

  def test_it_has_attributes
    vendor = Vendor.new("Rocky Mountain Fresh")

    assert_equal "Rocky Mountain Fresh", vendor.name
    expected_inventory = {}
    assert_equal expected_inventory, vendor.inventory
  end

  def test_it_can_stock_and_check_stock
    vendor = Vendor.new("Rocky Mountain Fresh")

    assert_equal 0, vendor.check_stock(@item1)

    vendor.stock(@item1, 30)

    expected_inventory = {@item1 => 30}
    assert_equal expected_inventory, vendor.inventory

    assert_equal 30, vendor.check_stock(@item1)

    vendor.stock(@item1, 25)

    assert_equal 55, vendor.check_stock(@item1)

    vendor.stock(@item2, 12)

    expected_inventory = {@item1 => 55, @item2 => 12}
    assert_equal expected_inventory, vendor.inventory
  end

  def test_it_knows_potential_revenue
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    #=> #<Item:0x007f9c56740d48...>
    item2 = Item.new({name: 'Tomato', price: "$0.50"})
    #=> #<Item:0x007f9c565c0ce8...>
    item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    #=> #<Item:0x007f9c562a5f18...>
    item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    #=> #<Item:0x007f9c56343038...>

    vendor1 = Vendor.new("Rocky Mountain Fresh")
    #=> #<Vendor:0x00007fe1348a1160...>
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)

    vendor2 = Vendor.new("Ba-Nom-a-Nom")
    #=> #<Vendor:0x00007fe1349bed40...>
    vendor2.stock(item4, 50)
    vendor2.stock(item3, 25)

    vendor3 = Vendor.new("Palisade Peach Shack")
    #=> #<Vendor:0x00007fe134910650...>
    vendor3.stock(item1, 65)

    assert_equal 29.75, vendor1.potential_revenue
    assert_equal 345.00, vendor2.potential_revenue
    assert_equal 48.75  , vendor3.potential_revenue
  end

end
