class OrderProduct < ApplicationRecord
 belongs_to :order, optional: true
  belongs_to :product
  validates :product_id, uniqueness: { scope: :order, message: -> (obj, data) do
     "Duplicate products" 
  end}
  validates :product_id, presence: true
  validates :quantity, presence: {message: "Quantity can't be blank."}, numericality: { greater_than: 0, message: 'Quantity should be greater than 0' }
end
