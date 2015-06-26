#encoding: utf-8

class Image < ActiveRecord::Base

  include Reorderable

  belongs_to :imageable, polymorphic: true
  belongs_to :image_type
  has_attached_file :attachment,
    styles: {
      lightbox: '1000x1000>',
      presentational: '1000x1000>',
      technical: '400x400>',
      thumbnail: '200x200>',
      icon: '25x25>',
    }

  scope :by_type, -> (type) { joins(:image_type).where(image_types: {name: type}) }

  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\Z/

end
