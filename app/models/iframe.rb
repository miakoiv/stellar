#encoding: utf-8

class Iframe < ActiveRecord::Base

  resourcify
  include Authority::Abilities
  include Reorderable

  #---
  belongs_to :product

  default_scope { sorted }

  #---
  validates :product_id, presence: true
  validates :html, presence: true

  #---
  def to_s
    html.html_safe
  end
end
