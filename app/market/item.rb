module Market

  class Item
    # Items have a name
    # Items have a price.
    # An item can be active or inactive.
    # An item has an owner.

    attr_accessor :name, :price, :owner, :active

    # constructor - give a name to the item and set a specified price
    # @param [String] name - name of the item
    # @param [Numeric] price - price of the item
    def self.named_priced(name, price)
      item = self.new
      item.name = name
      item.price = price
      item.active = false
      item
    end

    # activate the item
    def activate
      self.active = true
    end

    # deactivate the item
    def inactivate
      self.active = false
    end
  end
end