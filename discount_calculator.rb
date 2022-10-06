require_relative "line_item"

class DiscountCalculator
  attr_reader :order

  SINGLE_SHIRT_PRICE = 800 # Price in cents
  DISCOUNTS = [
    {id: 1, items: 2, amount: 5, price_savings: SINGLE_SHIRT_PRICE * 2 * 0.05},
    {id: 2, items: 3, amount: 10, price_savings: SINGLE_SHIRT_PRICE * 3 * 0.1},
    {id: 3, items: 4, amount: 20, price_savings: SINGLE_SHIRT_PRICE * 4 * 0.2},
    {id: 4, items: 5, amount: 25, price_savings: SINGLE_SHIRT_PRICE * 5 * 0.25}
  ].freeze

  def initialize(raw_order = {})
    @order = normalize_order(raw_order)
  end

  # Returns the final price of the order, in cents, *after* the greatest possible
  # discount has been applied
  def calculate
    base_order_price = order.count * SINGLE_SHIRT_PRICE

    base_order_price - greatest_possible_amount_saved
  end

  private

  # Returns the discount record corresponding to the number of items in the group.
  # Returns `nil` if no discount can be applied for the given size
  def discount_for_group_size(size)
    DISCOUNTS.find { |discount| discount[:items] == size }
  end

  # Returns either the `:price_savings` field from the relevant discount, or 0
  # if no discount can be applied to the provided size
  def price_savings_for_group_size(size)
    discount = discount_for_group_size(size)

    return 0 unless discount

    discount[:price_savings]
  end

  # Walks through every possible combination of discounts and returns the
  # largest possible total savings.
  def greatest_possible_amount_saved
    discount_items_range.to_a.reverse.reduce(0) do |savings, n|
      groups = []
      items = order.dup

      until items.empty?
        group = items.uniq { |item| item.name }.take(n) # Take the biggest possible group of unique items, up to size n
        groups << group
        items -= group # Array#- remove *all* matching elements, so we can't just use symbols or strings to represent items
      end

      amount_saved = groups.map { |group| price_savings_for_group_size(group.count) }.sum

      if amount_saved > savings
        amount_saved
      else
        savings
      end
    end
  end

  def normalize_order(raw_order)
    raw_order.reduce([]) do |arr, (name, quantity)|
      arr << quantity.times.map { LineItem.new(name: name) }
    end.flatten
  end

  def discount_items_range
    Range.new(*DISCOUNTS.minmax_by { |discount| discount[:items] }.map { |discount| discount[:items] })
  end
end
