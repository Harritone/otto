class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy, inverse_of: :customer

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :zipcode, presence: true

  def full_name
    self.first_name + ' ' + self.last_name
  end
end
