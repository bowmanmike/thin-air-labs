class OrderItem
  attr_reader :name
  attr_accessor :discount

  def initialize(attrs = {})
    @name = attrs[:name]
    @discount = nil
  end
end

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
    @order = []
    normalize_order(raw_order)
  end

  def calculate
    possibilities = (2..5).to_a.reverse_each.with_object([]) do |n, ary|
      groups = []
      items = order.dup

      until items.empty?
        group = items.uniq { |item| item.name }.take(n)
        groups << group
        items -= group
      end
      ary << groups
    end

    result = possibilities.max_by do |basket|
      basket.map do |discount_group|
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
    raw_order.each do |name, quantity|
      quantity.times { @order << OrderItem.new(name: name) }
    end
  end
end
