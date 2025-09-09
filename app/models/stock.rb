class Stock < ApplicationRecord
  validates :description, uniqueness: true, presence: true # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :stock_date, presence: true

  belongs_to :user
  has_many :products, dependent: :destroy
end
