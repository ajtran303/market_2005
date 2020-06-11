require 'date'

class Market
  attr_reader :name, :vendors, :date

  def self.get_date
    Date.today.strftime("%d/%m/%y")
  end

  def initialize(name)
    @name = name
    @vendors = []
    @date = Market.get_date
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.select do |vendor|
      vendor.inventory.keys.include?(item)
    end
  end

  def sorted_item_list
    @vendors.flat_map do |vendor|
      vendor.inventory.keys.map {|item| item.name}
    end.sort.uniq
  end

  def total_inventory
    market_inventory = Hash.new do |market_inventory, item|
      market_inventory[item] = {quantity: 0, vendors: []}
    end

    vendors.each do |vendor|
      vendor.inventory.each do |vendor_item, quantity|
        market_inventory[vendor_item][:quantity] += quantity
        market_inventory[vendor_item][:vendors] << vendor
      end
    end

    market_inventory
  end

  def overstocked_items
    total_inventory.reduce([]) do |overstock, (item, details)|
      overstock << item if details[:quantity] > 50 && details[:vendors].size > 1
      overstock
    end
  end

end
