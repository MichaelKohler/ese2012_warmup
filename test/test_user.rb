require "test/unit"
require "app/market/user"
require "app/market/item"

class UserTest < Test::Unit::TestCase

  def test_has_name
    user = Market::User.named("John")
    assert(user.name.to_s.include?("John"), "name is not John!")
  end

  def test_has_name_and_credit
    user = Market::User.named_credit("John", 200)
    assert(user.name.to_s.include?("John"), "name is not John!")
    assert(user.credit == 200, "credit is not 200!")
  end

  def test_has_initial_credit
    user = Market::User.named("Jim")
    assert(user.credit == 100, "initial credit is not 100!")
  end

  def test_has_more_credit
    user = Market::User.named("Jim")
    user.increase_credit(50)
    assert(user.credit == 150, "credit is not 150!")
  end

  def test_has_less_credit
    user = Market::User.named("Hans")
    user.decrease_credit(50)
    assert(user.credit == 50, "credit is not 50!")
  end

  def test_add_item
    # list is empty now
    user = Market::User.named("DrMuster")
    assert(user.get_sell_items.length == 0, "sell list is not empty")
    someitem = Market::Item.named_priced("someItem", 300)
    someitem.owner = Market::User.named("Owner!")
    user.add_item(someitem)
    assert(user.get_sell_items.include?(someitem), "item was not added!")
  end

  def test_list_all_sell_items
    otheritem = Market::Item.named_priced("otherItem", 50)
    someitem = Market::Item.named_priced("someItem", 550)
    otheritem.owner = Market::User.named("Owner!")
    user = Market::User.named("Foo")
    user.add_item(otheritem)
    user.add_item(someitem)
    # list should have 2 sell items now
    assert(user.get_sell_items.length == 2, "there are not 2 items in the sell list!")
    assert(user.get_sell_items.include?(otheritem), "otherItem is not in the sell list!")
    assert(user.get_sell_items.include?(someitem), "someItem is not in the sell list!")
  end

  def test_fail_not_enough_credit
    item = Market::Item.named_priced("reallyExpensiveItem", 5000)
    user = Market::User.named("Buyer")
    owner = Market::User.named("Owner")
    owner.add_item(item)
    assert(!user.buy_item?(item), "user was able to buy too expensive item!")
  end

  def test_become_owner_at_trade
    user = Market::User.named("Buyer")
    item = Market::Item.named_priced("normalItem", 100)
    owner = Market::User.named("Owner")
    owner.add_item(item)
    user.buy_item?(item)
    assert(user.get_items.length == 1, "user was not able to buy!")
    assert(item.owner == user, "user is not the owner!")
  end

  def test_transfer_credit_at_trade
    user = Market::User.named("Buyer")
    item = Market::Item.named_priced("normalItem", 100)
    owner = Market::User.named("Owner")
    owner.add_item(item)
    user.buy_item?(item)
    assert(user.credit == 0, "user has too much credit!")
    assert(owner.credit == 100, "owner has too less credit!")
  end

  def test_removes_from_user
    user = Market::User.named("Buyer")
    item = Market::Item.named_priced("normalItem", 100)
    owner = Market::User.named("Owner")
    owner.add_item(item)
    user.buy_item?(item)
    assert(owner.get_sell_items.length == 0, "owner still has the item on his list!")
  end

  def test_fail_inactive
    user = Market::User.named("Buyer")
    item = Market::Item.named_priced("normalItem", 100)
    owner = Market::User.named("Owner")
    owner.add_item(item)
    item.inactivate
    assert(!user.buy_item?(item), "user was able to buy the inactive item!")
  end

end