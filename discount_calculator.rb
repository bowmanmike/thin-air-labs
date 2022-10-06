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

  def calculate
    possibilities = discount_items_range.to_a.reverse_each.with_object([]) do |n, ary|
      groups = []
      items = order.dup # Create a fresh copy of the order for each iteration so we can check for all possibilities

      until items.empty?
        group = items.uniq { |item| item.name }.take(n) # Take the biggest possible group of unique items, up to size n
        groups << group
        items -= group # Array#- remove *all* matching elements, so we can't just use symbols or strings to represent items
      end
      ary << groups
    end

    result = possibilities.max_by do |basket|
      basket.map do |discount_group|
        # TODO: probably should be able to dedupe the discount_for_group_size calls in this section
        discount_for_group_size(discount_group.count)[:price_savings]
      end.sum
    end

    base_price = order.count * SINGLE_SHIRT_PRICE
    total_discount = result.map(&:count).map { |c| discount_for_group_size(c)[:price_savings] }.sum

    base_price - total_discount
  end

  def discount_for_group_size(size)
    DISCOUNTS.find { |discount| discount[:items] == size } || {price_savings: 0}
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
