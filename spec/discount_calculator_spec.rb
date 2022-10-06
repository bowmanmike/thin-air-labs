require_relative "../discount_calculator"

RSpec.describe DiscountCalculator do
  context "#calculate" do
    it "applies only the 5-piece discount if that's all that's possible" do
      order = {shirt_1: 1, shirt_2: 1, shirt_3: 1, shirt_4: 1, shirt_5: 1}
      expected_price = 3000

      expect(DiscountCalculator.new(order).calculate).to eq expected_price
    end

    it "correctly calculates the discount for a complex order" do
      order = {shirt_1: 2, shirt_2: 2, shirt_3: 2, shirt_4: 1, shirt_5: 1}
      expected_price_cents = 5120

      expect(DiscountCalculator.new(order).calculate).to eq(expected_price_cents)
    end
  end
end
