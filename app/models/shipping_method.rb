class ShippingMethod < ApplicationRecord

  resourcify
  include Authority::Abilities
  include Trackable
  include Pictureable

  monetize :free_shipping_from_cents, allow_nil: true

  #---
  belongs_to :store
  has_many :shipments

  # Reference to an internal product acting as the shipping cost for this method.
  belongs_to :shipping_cost_product, class_name: 'Product', optional: true

  # Products specifying this shipping method can be used to ship them.
  has_and_belongs_to_many :products

  # Message definitions attached to this shipping method, if any.
  has_many :messages, as: :context

  # A reference to a page containing pertinent details displayed during
  # checkout as a button opening the page contents in a modal.
  belongs_to :detail_page, class_name: 'Page', optional: true

  scope :active, -> { where '(shipping_methods.enabled_at IS NULL OR shipping_methods.enabled_at <= :today) AND (shipping_methods.disabled_at IS NULL OR shipping_methods.disabled_at > :today)', today: Date.current }

  #---
  def active?
    (enabled_at.nil? || !enabled_at.future?) &&
    (disabled_at.nil? || disabled_at.future?)
  end

  def shipping_gateway_class
    "ShippingGateway::#{shipping_gateway}".constantize
  end

  def message_stages
    ['shipment']
  end

  def to_s
    name
  end
end
