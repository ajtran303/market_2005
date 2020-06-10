class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
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
    vendors.reduce(Hash.new { |market_inventory, item| market_inventory[item] = {quantity: 0, vendors: []} }) do |acc, vendor|
      vendor.inventory.each do |vendor_item, quantity|
        acc[vendor_item][:quantity] += quantity
        acc[vendor_item][:vendors] << vendor
      end
      acc
    end
  end

end
