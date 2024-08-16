class Pizza < ApplicationRecord
  has_many :pizza_toppings, dependent: :destroy, inverse_of: :pizza
  has_many :toppings, through: :pizza_toppings

  validates :name, presence: true
  validates_uniqueness_of :name, uniqueness: true, case_sensitive: false

  accepts_nested_attributes_for :toppings, allow_destroy: true,
                                  reject_if: :all_blank

  def topping_names
    toppings.map { |t| t.name }.join(', ')
  end
end
