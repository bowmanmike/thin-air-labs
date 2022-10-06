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

  context "#discount_applies?" do
    it "returns true if the discount can be applied to the order" do
      order = {shirt_1: 1, shirt_2: 2}
      discount = {id: 1, items: 2, amount: 5}

      expect(DiscountCalculator.new(order).discount_applies?(discount)).to be true
    end

    it "returns false if the discount cannot be applied to the order" do
      order = {shirt_1: 1, shirt_2: 2, shirt_3: 0}
      discount = {id: 1, items: 3, amount: 5}

      expect(DiscountCalculator.new(order).discount_applies?(discount)).to be false
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
