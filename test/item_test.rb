require "minitest/autorun"
require "minitest/pride"
require "./lib/item"

class ItemTest < MiniTest::Test

  def test_it_exists
    item1 = Item.new({name: 'Peach', price: "$0.75"})
    #=> #<Item:0x007f9c56740d48...>

    assert_instance_of Item, item1
  end

  def test_it_has_attributes
    item2 = Item.new({name: 'Tomato', price: '$0.50'})
    #=> #<Item:0x007f9c565c0ce8...>

    assert_equal "Tomato", item2.name
    assert_equal 0.50, item2.price
  end

end
