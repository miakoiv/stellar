class Segment < ApplicationRecord

  store :metadata, accessors: [
    :header,          # headline for category, department segments, etc.
    :subhead,         # subhead to the headline
    :url,             # url to external resource, such as video
    :min_width,       # min width for gallery items, etc.
    :min_height,      # min height for google maps and empty segments
    :gutter,          # gutter width for galleries and media segments
    :width_ratio,     # width ratio for media objects
    :grid_columns,    # column count for grid views like categories
    :grid_lines,      # enable grid lines between grid elements
    :grid_disable_xs, # disable grid layout on extra small viewports
    :line_height,     # line height setting for text segments
    :hyphens,         # enable hyphenation for paragraph content
    :masonry,         # enable masonry on product cards
    :tapestry,        # display background images in front of background colors
    :swiper,          # enable swiper on product cards
    :image_sizing,    # image sizing options, one of original, contain, cover
    :thumbnails,      # use thumbnails for gallery pictures
    :lightbox,        # link images to lightboxed larger variants
    :slide_effect,    # slideshow transition effect
    :slide_delay,     # slideshow autoplay delay between slides
    :slide_speed,     # slideshow transition speed
    :max_items,       # number of items to show in category, department segments
    :product_scope,   # product sorting scope in category, department segments
    :show_more,       # flag to include a show more link when max items exceeded
    :map_location,    # location for centering google map segments
    :map_marker,      # flag to display the location marker
    :map_zoom,        # zoom factor of google map segments
    :map_theme,       # map theme as a JS snippet
    :content_class,   # content feed class in the ContentGateway module
    :content_type,    # content type in context of the content class
    :facebook_page,   # page id for facebook feeds
    :facebook_token,  # access token for the facebook feed
    :inverse,         # flag to invert things, like colour schemes or layouts
    :shadow,          # drop shadow selection
    :css_classes,     # additional custom CSS classes
    :jumbotron,       # flag to apply the jumbotron class to segment contents
    :animation,       # animation applied to the segment when scrolled into view
    :velocity,        # animation velocity, one of slowest, slow, normal, fast
  ], coder: JSON

  resourcify
  include Authority::Abilities
  include Trackable
  include Documentable
  include Pictureable
  include Reorderable
  include Borderable
  include Stylable

  #---
  RESOURCE_TYPES = %w{Page Category Promotion Product Department}.freeze

  ALIGNMENTS = %w{align-top align-middle align-bottom}.freeze

  JUSTIFICATIONS = %w{justify-left justify-center justify-right}.freeze

  SHAPES = [
    ['2:3', 'shape-2-3'],
    ['3:4', 'shape-3-4'],
    ['1:1', 'shape-square'],
    ['4:3', 'shape-4-3'],
    ['13:9', 'shape-13-9'],
    ['3:2', 'shape-3-2'],
    ['5:3', 'shape-5-3'],
    ['16:9', 'shape-16-9'],
    ['2:1', 'shape-two-one'],
    ['21:9', 'shape-21-9'],
    ['3:1', 'shape-three-one'],
    ['4:1', 'shape-four-one'],
  ].freeze

  GRID_COLUMNS = %w{1 2 3 4 6 12}.freeze

  IMAGE_SIZES = %w{sizing-original sizing-contain sizing-cover}.freeze

  LINE_HEIGHTS = %w{line-height-compact line-height-default line-height-loose line-height-double}.freeze

  SHADOWS = %w{shadow-none shadow-light shadow-medium shadow-heavy}.freeze

  ANIMATIONS = %w{
    bounceIn bounceInDown bounceInLeft bounceInRight bounceInUp
    fadeIn fadeInDown fadeInLeft fadeInRight fadeInUp
    zoomIn zoomInDown zoomInLeft zoomInRight zoomInUp
    slideIn slideInDown slideInLeft slideInRight slideInUp
  }.freeze

  VELOCITIES = %w{velocity-slowest velocity-slow velocity-normal velocity-fast}.freeze

  SLIDE_EFFECTS = %w{slide fade cube coverflow flip}.freeze

  CONTENT_CLASSES = %w{OikotieAsunnot ArticleFeed HeadlineFeed}.freeze

  #---
  enum template: {
    text: 1,
    media: 7,
    picture: 2,
    gallery: 3,
    slideshow: 8,
    product: 12,
    category: 11,
    tag: 15,
    promotion: 13,
    department: 14,
    feature: 20,
    google_map: 4,
    video_player: 5,
    documentation: 6,
    facebook_feed: 30,
    content_feed: 31,
    navigation_menu: 50,
    category_menu: 51,
    empty: 0,
    reference: 98,
    raw: 99,
  }

  #---
  belongs_to :column, touch: true
  belongs_to :resource, polymorphic: true, optional: true
  has_many :referring_segments, class_name: 'Segment', as: :resource, inverse_of: :resource

  accepts_nested_attributes_for :pictures

  validates :css_classes, format: {with: /\A(-?[_a-zA-Z]+[_a-zA-Z0-9-]*)(?:\s+\g<1>)*\z/}, allow_blank: true

  before_validation :clear_unwanted_attributes, if: :persisted?
  after_save :schedule_content_update,
    if: -> (segment) { segment.saved_change_to_body? }

  default_scope {
    joins(:column)
    .order('columns.priority, segments.priority')
  }
  scope :with_content, -> { where(template: [1, 7, 99]) }

  #---
  def self.default_settings
    {
      template: 'empty',
      margin_top: 20,
      margin_bottom: 20,
      min_width: 200,
      gutter: 10,
      width_ratio: 25,
      line_height: 'line-height-default',
      image_sizing: 'sizing-contain',
      thumbnails: true,
      slide_effect: 'slide',
      shadow: 'shadow-none',
      velocity: 'velocity-slow'
    }
  end

  def self.resource_type_options
    RESOURCE_TYPES.map { |t| [Segment.human_attribute_value(:resource_type, t.underscore), t] }
  end

  def self.template_options
    Segment.templates.keys.map { |t| [Segment.human_attribute_value(:template, t), t] }
  end

  def self.alignment_options
    ALIGNMENTS.map { |a| [Segment.human_attribute_value(:alignment, a), a] }
  end

  def self.justification_options
    JUSTIFICATIONS.map { |j| [Segment.human_attribute_value(:justification, j), j] }
  end

  def self.grid_columns_options
    GRID_COLUMNS
  end

  def self.line_height_options
    LINE_HEIGHTS.map { |h| [Segment.human_attribute_value(:line_height, h), h] }
  end

  def self.image_sizing_options
    IMAGE_SIZES.map { |s| [Segment.human_attribute_value(:image_sizing, s), s] }
  end

  def self.shadow_options
    SHADOWS.map { |s| [Segment.human_attribute_value(:shadow, s), s] }
  end

  def self.animation_options
    ANIMATIONS
  end

  def self.velocity_options
    VELOCITIES.map { |v| [Segment.human_attribute_value(:velocity, v).html_safe, v] }
  end

  def self.slide_effect_options
    SLIDE_EFFECTS.map { |e| [Segment.human_attribute_value(:slide_effect, e), e] }
  end

  def self.content_class_options
    CONTENT_CLASSES.map { |c| ["ContentGateway::#{c}".constantize.model_name.human, c] }
  end

  #---
  def has_content?
    text? || media? || feature? || raw?
  end

  def has_pictures?
    picture? || gallery? || slideshow? || media? || feature?
  end

  def edit_in_place?
    text? || media? || feature?
  end

  # If true, the admin template is not rendered on the settings panel.
  def without_settings?
    text? || raw?
  end

  def has_min_height?
    empty? || google_map?
  end

  def fixed_ratio?
    aspect_ratio.present?
  end

  def animation_class
    return nil unless animation.present?
    "animation #{velocity}"
  end

  def grid_columns
    super.presence || '3'
  end

  def grid_columns_class
    ["columns-#{grid_columns}", grid_disable_xs? && 'grid-disable-xs']
  end

  def shape_options
    shapes = Segment::SHAPES.map { |ratio, name| ratio }
    shapes.unshift(aspect_ratio) unless shapes.include?(aspect_ratio)
    shapes.map { |shape| {value: shape} }
  end

  def picture_options
    {purpose: ['presentational'], variant: Image::STYLES}
  end

  # Only feature segments have a background picture.
  def background_picture
    feature? && cover_picture
  end

  # Defines accessors to boolean settings not generated by Rails.
  %w[inverse jumbotron map_marker grid_lines grid_disable_xs hyphens masonry tapestry swiper show_more thumbnails lightbox].each do |method|
    alias_method "#{method}?", method
    define_method("#{method}=") do |value|
      super(['1', 1, true].include?(value))
    end
  end

  # Generates a duplicate with duplicated content.
  def duplicate
    dup.tap do |c|
      c.column = nil
      pictures.each do |picture|
        c.pictures << picture.duplicate
      end
    end
  end

  # Assign the attributes of this segment to refer to another segment.
  def refer(another)
    self.assign_attributes(
      template: 'reference',
      aspect_ratio: another.aspect_ratio,
      stretch: another.stretch,
      alignment: another.alignment,
      justification: another.justification,
      margin_top: another.margin_top,
      margin_bottom: another.margin_bottom,
      padding_vertical: another.padding_vertical,
      padding_horizontal: another.padding_horizontal,
      foreground_color: another.foreground_color,
      background_color: another.background_color,
      body: another.body,
      metadata: another.metadata,
      content: nil,
      inline_styles: another.inline_styles
    )
    self.resource = another
  end

  def to_s
    human_attribute_value(:template).capitalize
  end

  def to_partial_path
    "segments/templates/#{template}"
  end

  private

  def clear_unwanted_attributes
    self.resource_id = nil if will_save_change_to_template?
    self.min_height = nil unless has_min_height?
  end

  def schedule_content_update
    ContentGenerationJob.perform_later(self)
  end
end
