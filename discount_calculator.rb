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
    total_discount = generate_possible_discount_combinations
      .then { |combinations| biggest_savings_discount_combination(combinations) }
      .then { |discount_combination| total_savings_for_discount_combination(discount_combination) }

    base_order_price - total_discount
  end

  # TODO: Should these methods all be private? Technically, they're implementation details
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

  def total_savings_for_discount_combination(group)
    group.map(&:count).map { |c| price_savings_for_group_size(c) }.sum
  end

  # TODO: may be possible to replace these two following methods with a single call to reduce
  # Enumerates all applicable discount combinations for an order.
  def generate_possible_discount_combinations
    discount_items_range.to_a.reverse_each.with_object([]) do |n, combinations|
      groups = []
      items = order.dup # Create a fresh copy of the order for each iteration so we can check for all possibilities

      until items.empty?
        group = items.uniq { |item| item.name }.take(n) # Take the biggest possible group of unique items, up to size n
        groups << group
        items -= group # Array#- remove *all* matching elements, so we can't just use symbols or strings to represent items
      end
      combinations << groups
    end
  end

  def biggest_savings_discount_combination(possibilities)
    possibilities.max_by do |basket|
      basket.map do |discount_group|
        price_savings_for_group_size(discount_group.count)
      end.sum
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
