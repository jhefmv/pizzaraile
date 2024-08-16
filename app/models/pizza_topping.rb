class PizzaTopping < ApplicationRecord
  belongs_to :pizza, inverse_of: :pizza_toppings
  belongs_to :topping, inverse_of: :pizza_toppings

  validates :pizza, :topping, presence: true
end
