require "test/unit"
require "app/market/user"

class UserTest < Test::Unit::TestCase

  def setup
    user = Market::User.named_credit("John", 200)
    user
  end

  def shouldHaveName
    assert(user.name.to_s.include?("John"), "name is not John!")
  end

  def shouldHaveCredit
    assert(user.credit == 200, "credit is not 200!")
  end

  def shouldHaveMoreCredit
    user.increaseCredit(50)
    assert(user.credit == 250, "credit is not 250!")
  end

  def shouldHaveLessCredit
    user.decreaseCredit(50)
    assert(user.credit == 200, "credit is not 200!")
  end

  def shouldAddItem
    # list is empty now
    assert(user.get_sell_items.length == 0, "sell list is not empty")
    someItem = Market::Item.named_priced("someItem", 300)
    user.addItem(someItem)
    assert(user.get_sell_items.include?(someItem), "item was not added!")
  end

  def shouldListAllSellItems
    otherItem = Market::Item.named("otherItem")
    user.addItem(otherItem);
    # list should have 2 sell items now
    assert(user.get_sell_items.length == 2, "there are not 2 items in the sell list!")
    assert(user.get_sell_items.include?(someItem), "someItem is not in the sell list!")
    assert(user.get_sell_items.include?(otherItem), "otherItem is not in the sell list!")
  end

  def shouldFailIfNotEnoughCredit
    itemToBuy = Market::Item.named_priced("itemToSell", 500)
    user.buyItem(itemToBuy)
    # list should be still still be 0, since we couldn't buy the first item now
    assert(user.get_items.length == 1, "user was able to buy too expensive item!")
  end

  def shouldBecomeOwnerAtTrade
    itemToBuy = Market::Item.named_priced("itemToBuy", 50)
    itemToBuy.activate
    user.buyItem(itemToBuy)
    assert(user.get_items.length == 2, "user was not able to buy!")
    assert(itemToBuy.owner == user, "user is not the owner!")
  end

  def shouldTransferCreditAtTrade
    # after shouldBecomeOwnerAtTrade we should have 50 credits less
    assert(user.credit == 150, "user has too much credit!")
  end

  def shouldFailTradeBecauseItemIsInactive
    inactiveItemToBuy = Market::Item.named_priced("inactiveItem", 100)
    # item is inactive per default so we don't need to inactivate it here
    user.buyItem(inactiveItemToBuy)
    # list should still be 2, since we couldn't buy the third item now
    assert(user.get_items.length == 2, "user was able to buy the inactive item!")
  end

end