require "test/unit"
require "app/market/item"

class ItemTest < Test::Unit::TestCase

  attr_accessor :item, :owner

  def setup
    item = Market::Item.named_priced("testItem", 100)
    owner = Market::User.named("John")
    item.owner = owner
    item.active = true
    item
  end

  def test_HaveName
    assert(item.name.to_s.include?("testItem"), "item has a wrong name!")
  end

  def test_HavePrice
    assert(item.price == 100, "item has a wrong price!")
  end

  def test_HaveOwner
    assert(item.owner == owner, "item has an incorrect owner!")
  end

  def test_ChangeState
    item.activate
    assert(item.active == true, "item is still inactive!")
  end

  def test_BeInactiveAfterTrade
    user = Market::User.named("Jim")
    user.buy_item?(item)
    assert(!item.active, "item is still active!")
  end
end