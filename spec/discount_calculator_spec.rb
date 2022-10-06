require_relative "../discount_calculator"

RSpec.describe DiscountCalculator do
  context "#calculate" do
    it "applies the greatest discount for a simple order" do
      order = {shirt_1: 1, shirt_2: 1, shirt_3: 1, shirt_4: 1, shirt_5: 1}
      expected_price_cents = 3000

      expect(DiscountCalculator.new(order).calculate).to eq expected_price_cents
    end

    it "applies no discount if the order contains a single item" do
      order = {shirt_1: 1}
      expected_price_cents = 800

      expect(DiscountCalculator.new(order).calculate).to eq expected_price_cents
    end

    it "applies no discount if the order contains only multiple copies of the same item" do
      order = {shirt_1: 2}
      expected_price_cents = 1600

      expect(DiscountCalculator.new(order).calculate).to eq expected_price_cents
    end

    it "applies the correct discount for an order with multiple groups" do
      # Largest single discount combination would be one group of 5 and one single item left over
      # However, this doesn't result in the maximum discount. One group of 4 and one group
      # of 2 provide better savings.
      order = {shirt_1: 2, shirt_2: 1, shirt_3: 1, shirt_4: 1, shirt_5: 1}
      expected_price_cents = 3800

      expect(DiscountCalculator.new(order).calculate).to eq expected_price_cents
    end

    it "correctly calculates the discount for a complex order" do
      order = {shirt_1: 2, shirt_2: 2, shirt_3: 2, shirt_4: 1, shirt_5: 1}
      expected_price_cents = 5120

      expect(DiscountCalculator.new(order).calculate).to eq(expected_price_cents)
    end
  end
end
