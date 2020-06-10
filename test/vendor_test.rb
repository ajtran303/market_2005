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

end
