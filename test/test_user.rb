require "test/unit"
require "app/market/user"
require "app/market/item"

class UserTest < Test::Unit::TestCase

  def startup
    @@user = Market::User.named_credit("John", 200)
    @@itemToBuy = Market::Item.named_priced("itemToBuy", 50)
    @@previousOwner = Market::User.named("Jim")
    user
  end

  def test_HaveName
    assert(user.name.to_s.include?("John"), "name is not John!")
  end

  def test_HaveCredit
    assert(user.credit == 200, "credit is not 200!")
  end

  def test_HaveInitialCredit
    someUser = Market::User.named("Jim")
    assert(someUser.credit == 100, "initial credit is not 100!")
  end

  def test_HaveMoreCredit
    user.increaseCredit(50)
    assert(user.credit == 250, "credit is not 250!")
  end

  def test_HaveLessCredit
    user.decreaseCredit(50)
    assert(user.credit == 200, "credit is not 200!")
  end

  def test_AddItem
    # list is empty now
    assert(user.get_sell_items.length == 0, "sell list is not empty")
    someItem = Market::Item.named_priced("someItem", 300)
    someItem.owner = previousOwner
    user.add_item(someItem)
    assert(user.get_sell_items.include?(someItem), "item was not added!")
  end

  def test_ListAllSellItems
    otherItem = Market::Item.named_priced("otherItem", 50)
    otherItem.owner = previousOwner
    user.add_item(otherItem);
    # list test_ have 2 sell items now
    assert(user.get_sell_items.length == 2, "there are not 2 items in the sell list!")
    assert(user.get_sell_items.include?(otherItem), "otherItem is not in the sell list!")
  end

  def test_FailIfNotEnoughCredit
    itemToBuy.price = 500
    assert(!user.buy_item?(itemToBuy), "user was able to buy too expensive item!")
  end

  def test_BecomeOwnerAtTrade
    itemToBuy.owner = previousOwner
    itemToBuy.activate
    user.buy_item?(itemToBuy)
    assert(user.get_items.length == 2, "user was not able to buy!")
    assert(itemToBuy.owner == user, "user is not the owner!")
  end

  def test_TransferCreditAtTrade
    # after test_BecomeOwnerAtTrade we test_ have 50 credits less
    assert(user.credit == 150, "user has too much credit!")
  end

  def test_RemoveItemFromUserAtTrade
    assert(previousOwner.get_sell_items.include?(itemToBuy) == false, "user still has the item on his list!")
  end

  def test_FailTradeBecauseItemIsInactive
    inactiveItemToBuy = Market::Item.named_priced("inactiveItem", 100)
    # item is inactive per default so we don't need to inactivate it here
    user.buy_item?(inactiveItemToBuy)
    # list test_ still be 2, since we couldn't buy the third item now
    assert(user.get_items.length == 2, "user was able to buy the inactive item!")
  end

end