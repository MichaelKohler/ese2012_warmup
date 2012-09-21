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
      items = Array.new
    end

    # increase the balance
    # @param [Numeric] amount - amount to be added
    def increaseCredit(amount)
      self.credit += amount
    end

    # decrease the balance
    # @param [Numeric] amount - amount to be subtracted
    def decreaseCredit(amount)
      self.credit -= amount
    end

    # add a specified item to the selling list
    # @param [Item] item - item to be added
    def add_item(item)
      item.activate
      self.items.push(item)
    end

    # buy a specified item from another user
    # -> pay credits, change ownership, add item to user's list
    # @param [Item] item - item to be bought
    def buy_item?(item)
      return false if self.credit < item.price

      decreaseCredit(item.price)
      item.owner.increaseCredit(item.price)
      item.owner.remove_item_from_user(item)
      item.owner = self
      self.items.push(item)
      return true
    end

    # remove item from user's list due to it being sold
    # @param [Item] item - item to be removed
    def remove_item_from_user(item)
      self.items.delete(item)
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