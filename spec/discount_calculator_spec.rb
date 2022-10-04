require_relative "../discount_calculator"

RSpec.describe DiscountCalculator do
  context "#sanity_check" do
    it "works!" do
      expect(described_class.new.sanity_check).to eq "It works!"
    end
  end
end
