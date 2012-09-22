require "test/unit"
#require "app/market/item.rb"
#require "app/market/user.rb"
# To use relative imports, I found 

def relative path
  File.join(File.dirname(__FILE__), path)
end
require relative('../app/market/item')
require relative('../app/market/user')

# to be working


class ItemTest < Test::Unit::TestCase

  def test_has_name
    item = Market::Item.named_priced("testItem", 100)
    assert(item.name.to_s.include?("testItem"), "item has a wrong name!")
  end

  def test_has_price
    item = Market::Item.named_priced("testItem", 100)
    assert(item.price == 100, "item has a wrong price!")
  end

  def test_has_owner
    item = Market::Item.named_priced("testItem", 100)
    user = Market::User.named("John")
    user.add_item(item)
    assert(item.owner == user, "item has an incorrect owner!")
  end

  def test_changes_state
    item = Market::Item.named_priced("testItem", 100)
    item.activate
    assert(item.active, "item is still inactive!")
  end

  def test_is_inactive_after_trade
    user = Market::User.named("Buyer")
    item = Market::Item.named_priced("normalItem", 100)
    owner = Market::User.named("Owner")
    owner.add_item(item)
    user.buy_item?(item)
    assert(! user.get_sell_items.include?(item), "item is still active!")
  end
end
