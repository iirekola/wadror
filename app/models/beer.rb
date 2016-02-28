class Beer < ActiveRecord::Base

  include RatingAverage

  validates_presence_of :name
  validates_presence_of :style

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user



  def to_s
    return "#{name}, #{brewery.name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.first(n)
  end

end
