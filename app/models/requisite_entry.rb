class RequisiteEntry < ApplicationRecord

  include Reorderable

  belongs_to :product, touch: true
  belongs_to :requisite, class_name: 'Product'

  default_scope { sorted }
  scope :live, -> { joins(:requisite).merge(Product.live) }

  #---
  def to_s
    product.to_s
  end
end
