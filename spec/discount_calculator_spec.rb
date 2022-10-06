require_relative "../discount_calculator"

RSpec.describe DiscountCalculator do
  context "#calculate" do
    it "applies only the 5-piece discount if that's all that's possible" do
      order = {shirt_1: 1, shirt_2: 1, shirt_3: 1, shirt_4: 1, shirt_5: 1}
      expected_price_cents = 3000

      expect(DiscountCalculator.new(order).calculate).to eq expected_price_cents
    end

    it "applies no discount if the order contains a single item" do
      order = {shirt_1: 1}
      expected_price_cents = 800

      expect(DiscountCalculator.new(order).calculate).to eq expected_price_cents
    end

    it "applies no discount if the order contains multiple copies of the same item" do
      order = {shirt_1: 2}
      expected_price_cents = 1600

      expect(DiscountCalculator.new(order).calculate).to eq expected_price_cents
    end

    it "correctly calculates the discount for a complex order" do
      order = {shirt_1: 2, shirt_2: 2, shirt_3: 2, shirt_4: 1, shirt_5: 1}
      expected_price_cents = 5120

      expect(DiscountCalculator.new(order).calculate).to eq(expected_price_cents)
    end
  end
end
