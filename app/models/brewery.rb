class Brewery < ActiveRecord::Base
 include RatingAverage
 
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end
  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end
#  def average_rating
#    total = self.ratings.inject(0) {|sum, n| sum + n.score}
#    return total / self.ratings.count
#  end

end
