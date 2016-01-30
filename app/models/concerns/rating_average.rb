module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    summa = ratings.inject(0){|sum, rating| sum + rating.score}
    return summa/ratings.size.to_f
  end

end