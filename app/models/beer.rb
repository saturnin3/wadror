class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    total = 0
    self.ratings.each do |r|
     total += r.score
    end
    return total / self.ratings.count
  end
end
