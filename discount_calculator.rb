class DiscountCalculator
  attr_reader :order

  SINGLE_SHIRT_PRICE = 800 # Price in cents
  ORDER_DEFAULTS = {
    shirt_1: 0,
    shirt_2: 0,
    shirt_3: 0,
    shirt_4: 0,
    shirt_5: 0
  }.freeze

  def initialize(order = {})
    @order = normalize_order(order)
  end

  def calculate
    :not_implemented
  end

  def normalize_order(order)
    ORDER_DEFAULTS.merge(order).slice(*ORDER_DEFAULTS.keys)
  end
end
