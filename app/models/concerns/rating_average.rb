module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?
    total = self.ratings.inject(0) { |sum, n| sum + n.score }
    return total / self.ratings.count.to_f
  end

end
