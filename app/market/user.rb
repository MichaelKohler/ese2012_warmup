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
      user = self.new
      user.name = name
      user.credit = credit
      user
    end

    # initialize the items array
    def initialize
      self.items = Array.new
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
      self.items.push(item)
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

      self.decrease_credit(item.price)
      item.owner.increase_credit(item.price)
      item.owner.remove_item_from_user(item)
      item.owner = self
      item.inactivate
      self.items.push(item)
    end

    # remove item from user's list
    # @param [Item] item - item to be removed
    def remove_item_from_user(item)
      self.items.delete(item)
      item.owner = nil
    end

    # list of user's items to sell
    def get_sell_items
      self.items.select { |item| item.active }
    end

    # list of user's items
    def get_items
      self.items
    end
  end
end