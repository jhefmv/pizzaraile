require 'rails_helper'

RSpec.describe Pizza, type: :model do
  subject { described_class.new }

  describe 'associations' do
    it { is_expected.to have_many(:pizza_toppings) }
    it { is_expected.to have_many(:toppings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe '#topping_names' do
    it 'list toppings' do
      toppings = [{name: 'olives'}]
      valid_attribs = {
        name: 'A new pizza',
        toppings_attributes: toppings
      }
      new_pizza = Pizza.create(valid_attribs)
      expect(new_pizza.topping_names).to include(toppings.map { |t| t[:name] }.join(', '))
    end
  end
end
