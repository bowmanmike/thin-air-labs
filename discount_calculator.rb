class DiscountCalculator
  attr_reader :order
  attr_accessor :discount

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
    @discount = []
  end

  def calculate
    puts "HERE"
    5.downto(2).each_with_object(order.dup) do |num, order|
      require "debug"
      binding.break
      if order.all? { |_product, quantity| quantity >= 1 } # discount available
        discount << [5, 25]
        order.each { |product, quantity| order[product] = quantity - 1 unless quantity.zero? }
      end
    end
  end

  def normalize_order(order)
    ORDER_DEFAULTS.merge(order).slice(*ORDER_DEFAULTS.keys)
  end
end
