require 'rails_helper'

RSpec.describe Topping, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it { is_expected.to have_many(:pizza_toppings) }
    it { is_expected.to have_many(:pizzas) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
