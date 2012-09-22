require "test/unit"

def relative path
  File.join(File.dirname(__FILE__), path)
end
require relative('../app/market/item')
require relative('../app/market/user')

include Market

class UserTest < Test::Unit::TestCase

  def test_has_name
    user = User.init(:name => "John")
    assert(user.name.to_s.include?("John"), "name is not John!")
  end

  def test_has_name_and_credit
    user = User.init(:name => "John", :credit => 200)
    assert(user.name.to_s.include?("John"), "name is not John!")
    assert(user.credit == 200, "credit is not 200!")
  end

  def test_has_initial_credit
    user = User.init(:name => "Jim")
    assert(user.credit == 100, "initial credit is not 100!")
  end

  def test_has_more_credit
    user = User.init(:name => "Jim")
    user.increase_credit(50)
    assert(user.credit == 150, "credit is not 150!")
  end

  def test_has_less_credit
    user = User.init(:name => "Hans")
    user.decrease_credit(50)
    assert(user.credit == 50, "credit is not 50!")
  end

  def test_add_item
    # list is empty now
    user = User.init(:name => "DrMuster")
    assert(user.sell_items.length == 0, "sell list is not empty")
    someitem = Item.init(:name => "someItem", :price => 300)
    someitem.owner = User.init(:name => "Owner!")
    user.add_item(someitem)
    assert(user.sell_items.include?(someitem), "item was not added!")
  end

  def test_list_all_sell_items
    otheritem = Item.init(:name => "otherItem", :price => 50)
    someitem = Item.init(:name => "someItem", :price => 550)
    otheritem.owner = User.init(:name => "Owner!")
    user = User.init(:name => "Foo")
    user.add_item(otheritem)
    user.add_item(someitem)
    # list should have 2 sell items now
    assert(user.sell_items.length == 2, "there are not 2 items in the sell list!")
    assert(user.sell_items.include?(otheritem), "otherItem is not in the sell list!")
    assert(user.sell_items.include?(someitem), "someItem is not in the sell list!")
  end

  def test_fail_not_enough_credit
    item = Item.init(:name => "reallyExpensiveItem", :price => 5000)
    user = User.init(:name => "Buyer")
    owner = User.init(:name => "Owner")
    owner.add_item(item)
    assert(!user.buy_item?(item), "user could have bought the too expensive item!")
  end

  def test_become_owner_at_trade
    user = User.init(:name => "Buyer")
    item = Item.init(:credit => 100)
    owner = User.init(:name => "Owner")
    owner.add_item(item)
    user.buy_item(item) if user.buy_item?(item)
    assert(user.items.length == 1, "user was not able to buy!")
    assert(item.owner == user, "user is not the owner!")
  end

  def test_transfer_credit_at_trade
    user = User.init(:name => "Buyer")
    item = Item.init(:name => "normalItem", :price => 100)
    owner = User.init(:name => "Owner")
    owner.add_item(item)
    user.buy_item(item) if user.buy_item?(item)
    assert(user.credit == 0, "user has too much credit!")
    assert(owner.credit == 200, "owner has too less credit!")
  end

  def test_removes_from_user
    user = User.init(:name => "Buyer")
    item = Item.init(:name => "normalItem", :price => 100)
    owner = User.init(:name => "Owner")
    owner.add_item(item)
    user.buy_item(item) if user.buy_item?(item)
    assert(owner.sell_items.length == 0, "owner still has the item on his list!")
  end

  def test_fail_inactive
    user = User.init(:name => "Buyer")
    owner = User.init(:name => "Owner")
    item = Item.init(:active => false, :owner => owner)
    assert(!user.buy_item?(item), "user could have bought the inactive item!")
  end

end
