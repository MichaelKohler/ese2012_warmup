require "test/unit"
require "app/market/item"

class ItemTest < Test::Unit::TestCase

  def setup
    item = Market::Item.named_priced("testItem", 100)
    owner = Market::User.named("John")
    item.owner = owner
    item.active = true
    item
  end

  def shouldHaveName
    assert(item.name.to_s.include?("testItem"), "item has a wrong name!")
  end

  def shouldHavePrice
    assert(item.price == 100, "item has a wrong price!")
  end

  def shouldHaveOwner
    assert(item.owner == owner, "item has an incorrect owner!")
  end

  def shouldChangeState
    item.activate
    assert(item.active == true, "item is still inactive!")
  end

  def shouldBeInactiveAfterTrade
    user = Market::User.named("Jim")
    itemToSell = Market::Item.named_priced("sellItem", 100)
    user.buyItem(itemToSell)
    assert(itemToSell.active == false, "item is still active!")
  end
end