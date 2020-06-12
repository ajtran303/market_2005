class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory[item]
  end

  def stock(item, quantity)
    @inventory[item] += quantity
  end

  def potential_revenue
    @inventory.sum do |item, quantity|
      item.price * quantity
    end
  end

  def sell_stock(item, amount_to_sell)
    @inventory[item] -= amount_to_sell
  end

end
