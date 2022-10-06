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
  attr_accessor :applied_discounts

  SINGLE_SHIRT_PRICE = 800 # Price in cents
  DISCOUNTS = [
    {id: 1, items: 2, amount: 5, price_savings: SINGLE_SHIRT_PRICE * 2 * 0.05},
    {id: 2, items: 3, amount: 10, price_savings: SINGLE_SHIRT_PRICE * 3 * 0.1},
    {id: 3, items: 4, amount: 20, price_savings: SINGLE_SHIRT_PRICE * 4 * 0.2},
    {id: 4, items: 5, amount: 25, price_savings: SINGLE_SHIRT_PRICE * 5 * 0.25}
  ].freeze

  def initialize(raw_order = {})
    @order = []
    @discount = []
    @applied_discounts = []

    normalize_order(raw_order)
  end

  def calculate
    # potential_discounts = applicable_discounts
    # final_discounts = []
    # need to get the greatest sum of discount amounts?
    # Yeah. In the example, it shows that a 25% + 5% is less
    # of a discount than 20% + 20%
    # Need to basically find which discounts can be applied, and how
    # many times they can be applied. Tricky part is that there's some mutual
    # exclusivity
    # Can we just try to max the amount of price_savings?
    # that still doesn't get around the problem of needing to generate
    # multiple (all?) possible combos of discounts
    # brute force
    # start by applying the biggest discount
    # loop and keep applying discounts until the applicable_discounts is empty
    # that still only gives one permutation
    # It feels like theres an elegant solution out there using max_by, but
    # its just out of view
    # 1. calculate all permutations
    #   - HOW???
    # 2. max_by permutation discount value

    # rather than directly mutating the orders state, could just keep track
    # of which discount applies to which item, and tally them up in the discounts array

    # is it actually as simple as just finding the discount combo with the maximum
    # percentage of discount? that seems too simple, too naive. But it could be right?

    # until applicable_discounts.empty?
    # - starting at the biggest, sequentially apply discounts until none are left
    # - next iteration, start at the second biggest and apply biggest to smallest
    # sorted = DISCOUNTS.sort_by { |discount| discount[:price_savings] }.reverse
    # end

    # now we can quickly see when an item is discounted
    # can it possibly be as simple as: 4 is the most efficient category,
    # so we should make as many groups of 4 as possible, then go 5, 3, 2?
    # No, that doesn't work. A single group of 5 is more efficient than a
    # group of 4 plus a single.
    # But maybe if there can be multiple groups,then 4 is the best to prioritize?
    # if possible to make multiple groups, 4 + 1 extra group is more efficient than 5 and no extra groups

    # this will iterate, building as many possible combinations starting with groups of 5
    # then working down, then starting with 4, then working down, etc.
    possibilities = (2..5).to_a.reverse_each.with_object([]) do |n, ary|
      groups = []
      items = order.dup

      until items.empty?
        group = items.uniq { |item| item.name }.take(n)
        groups << group
        items -= group

        # require "pry-byebug"
        # binding.pry

        # don't need to actually apply the discount, we just need to remove the items from the pool temporarily
        # delete them from the items list, stick them in a new array and pass it to groups
        # apply_discount(n - 1) if items.count == n
      end
      ary << groups
    end

    # `possibilities` here is all the possible breakdowns
    # now we can just use max_by to sum the possibility array and get the biggest
    result = possibilities.max_by do |basket|
      basket.map do |discount_group|
        discount_for_group_size(discount_group.count)[:price_savings]
      end.sum
    end

    # now we jsut need to calculate the final price and apply the discount
    base_price = order.count * SINGLE_SHIRT_PRICE
    # require "pry-byebug"
    # binding.pry

    total_discount = result.map(&:count).map { |c| discount_for_group_size(c)[:price_savings] }.sum

    base_price - total_discount
  end

  def discount_for_group_size(size)
    DISCOUNTS.find { |discount| discount[:items] == size } || {price_savings: 0}
  end

  def unique_remaining_items(items)
    items.reject { |i| i.discount }.uniq { |i| i.name }
  end

  def build_group_of_size(remaining_items, size)
  end

  def apply_discount(id)
    discount = DISCOUNTS.find { |discount| discount[:id] == id }
    # walk through the order, picking the first of each unique item that has no discount,
    # and apply the discount
    # can use group by here to ensure we're only applying each discount to a single
    # distinct item
    # something like: order.group_by { |item| item.name }.each { |item_name, items| ...}
    order.each do |item|
      next if item.discount
      item.discount = discount[:amount]
    end
  end

  def applicable_discounts
    DISCOUNTS.each do |discount|
      applied_discounts << discount if discount_applies?(discount)
    end
  end

  def discount_applies?(discount)
    undiscounted_items = order.filter { |item| item.discount.nil? }
    undiscounted_items.group_by { |item| item.name }.count >= discount[:items]
  end

  def sum_order
    order.sum { |item| SINGLE_SHIRT_PRICE - (SINGLE_SHIRT_PRICE * (item.discount / 100.0)) }.to_i
  end

  def unique_items
    order.uniq { |item| item.name }
  end

  def normalize_order(raw_order)
    raw_order.each do |name, quantity|
      quantity.times { @order << OrderItem.new(name: name) }
    end
  end
end
