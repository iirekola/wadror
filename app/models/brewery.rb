class Brewery < ActiveRecord::Base

  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   less_than_or_equal_to: Proc.new { Time.now.year },
                                   only_integer: true }


  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers


  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

end
