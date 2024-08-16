require 'rails_helper'

RSpec.describe PizzaTopping, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:pizza) }
    it { is_expected.to belong_to(:topping) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:pizza) }
    it { is_expected.to validate_presence_of(:topping) }
  end
end
