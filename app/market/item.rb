module Market

  class Item
    # Items have a name
    # Items have a price.
    # An item can be active or inactive.
    # An item has an owner.

    attr_accessor :name, :price, :owner, :active

    # constructor - give a name to the item and set a specified price
    # @param [Object] params - dictionary of symbols
    def self.init(params={})
      item = self.new
      item.name = params[:name] || "default item"
      item.price = params[:price] || 0
      item.active = params[:active] || false
      item.owner = params[:owner]
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