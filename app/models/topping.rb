class Topping < ApplicationRecord
  has_many :pizza_toppings, dependent: :destroy, inverse_of: :topping
  has_many :pizzas, through: :pizza_toppings

  validates :name, presence: true
  validates_uniqueness_of :name, uniqueness: true, case_sensitive: false
end
