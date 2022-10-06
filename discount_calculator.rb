class DiscountCalculator
  attr_reader :order
  attr_accessor :applied_discounts

  SINGLE_SHIRT_PRICE = 800 # Price in cents
  ORDER_DEFAULTS = {
    shirt_1: 0,
    shirt_2: 0,
    shirt_3: 0,
    shirt_4: 0,
    shirt_5: 0
  }.freeze
  DISCOUNTS = [
    {id: 1, items: 2, amount: 5},
    {id: 2, items: 3, amount: 10},
    {id: 3, items: 4, amount: 20},
    {id: 4, items: 5, amount: 25}
  ].freeze

  def initialize(order = {})
    @order = normalize_order(order)
    @discount = []
    @applied_discounts = []
  end

  def calculate
  def applicable_discounts
    DISCOUNTS.each do |discount|
      applied_discounts << discount if discount_applies?(discount)
    end
  end

  def discount_applies?(discount)
    order.count { |_item, quantity| quantity > 0 } >= discount[:items]
  end

  def normalize_order(order)
    ORDER_DEFAULTS.merge(order).slice(*ORDER_DEFAULTS.keys)
  end
end
