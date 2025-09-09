class Product < ApplicationRecord
  belongs_to :stock
  before_validation :generate_product_code, if: -> { prod_code.blank? }

  private

  def generate_product_code
    self.prod_code = SecureRandom.alphanumeric(8).upcase
  end
end
