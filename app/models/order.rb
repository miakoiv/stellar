#encoding: utf-8

class Order < ActiveRecord::Base

  belongs_to :user
  belongs_to :order_type
  has_many :order_items


  def to_s
    new_record? ? 'New order' : "[#{created_at.to_s(:long)}] #{user}"
  end
end
