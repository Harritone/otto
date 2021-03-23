class Order < ApplicationRecord
  belongs_to :customer, optional: true, inverse_of: :orders
  has_many :order_products, inverse_of: :order, dependent: :destroy 
  has_many :products, through: :order_products

  accepts_nested_attributes_for :order_products, reject_if: :all_blank, allow_destroy: true
  scope :last_week, -> { where(created_at: (Time.now - 7.day)..Time.now) }

  def has_products?
    unless products.size > 0
      false
    end
  end
end
