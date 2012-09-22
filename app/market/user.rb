module Market

  class User
    # Users have a name.
    # Users have an amount of credits.
    # A new user has originally 100 credit.

    # A user can add a new item to the system with a name and a price; the item is originally inactive.
    # A user can buy active items of another user (inactive items can't be bought).
    # When a user buys an item, it becomes the owner; credit are transferred accordingly;
    # immediately after the trade, the item is inactive. The transaction fails if the buyer has not enough credits.
    # A user provides a method that lists his/her active items to sell.

    attr_accessor :name, :credit, :items

    # constructor - name only and give an initial balance of 100 credits
    # @param [String] name - name of the user
    def self.named(name)
      user = self.new
      user.name = name
      user.credit = 100
      user
    end

    # constructor - give a name and an specified initial balance of credits
    # @param [String] name - name of the user
    # @param [Numeric] credit - initial credit balance
    def self.named_credit(name, credit)
      # AK If you find yourself writing many very similar
      # constructors, I suggest passing a dictionary of 
      # symbols instead:
      # http://deepfall.blogspot.ch/2008/08/named-parameters-in-ruby.html
      user = self.new
      user.name = name
      user.credit = credit
      user
    end

    # initialize the items array
    def initialize
      self.items = Array.new # AK it is better to write 
      self.items = [] # and `{}` for empty dictionaries
    end

    # increase the balance
    # @param [Numeric] amount - amount to be added
    def increase_credit(amount)
      self.credit += amount
    end

    # decrease the balance
    # @param [Numeric] amount - amount to be subtracted
    def decrease_credit(amount)
      self.credit -= amount
    end

    # add a specified item to the selling list
    # @param [Item] item - item to be added
    def add_item(item)
      item.owner = self
      item.activate
      self.items.push(item) # AK There is also
      # self.items << item
    end

    # buy a specified item from another user
    # -> pay credits, change ownership, add item to user's list
    # when a user has not enough credits, the trade is not acceptable
    # @param [Item] item - item to be bought
    def buy_item?(item)
      return false if item == nil
      return false if item.owner == nil
      return false if self.credit < item.price
      return false if !item.active

      # AK methods ending in `?` should not change the state of the 
      # object. You can of course write `buy_item(item) if buy_item?(item)`
      self.decrease_credit(item.price)
      item.owner.increase_credit(item.price)
      item.owner.remove_item_from_user(item)
      item.owner = self
      item.inactivate
      self.items.push(item)
    end

    # remove item from user's list
    # @param [Item] item - item to be removed
    def remove_item_from_user(item) # AK this name is a bit redundant, isn't it?
      self.items.delete(item)
      item.owner = nil
    end

    # list of user's items to sell
    def get_sell_items # AK you seldom name it `get_...`
      self.items.select { |item| item.active }
    end

    # list of user's items
    def get_items # this doubles the accessor (items is aleady public)
      self.items
    end
  end
end
