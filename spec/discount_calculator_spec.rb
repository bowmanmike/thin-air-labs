require_relative "../discount_calculator"

RSpec.describe DiscountCalculator do
  context "#calculate" do
    it "correctly calculates the discount for a complex order" do
      order = {shirt_1: 2, shirt_2: 2, shirt_3: 2, shirt_4: 1, shirt_5: 1}
      calculator = DiscountCalculator.new(order)

      expected_price_cents = 5120

      expect(calculator.calculate).to eq(expected_price_cents)
    end
  end

  context "#normalize_order" do
    it "ensures valid default values are set for all new orders" do
      input = {shirt_1: 3}
      result = DiscountCalculator.new.normalize_order(input)

      expect(result).to eq({shirt_1: 3, shirt_2: 0, shirt_3: 0, shirt_4: 0, shirt_5: 0})
    end

    it "removed invalid keys" do
      input = {shirt_1: 2, foo: 15, bar: :invalid}
      result = DiscountCalculator.new.normalize_order(input)

      expect(result).to eq({shirt_1: 2, shirt_2: 0, shirt_3: 0, shirt_4: 0, shirt_5: 0})
    end
  end
end
