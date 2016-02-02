class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   #less_than_or_equal_to: 2016,
                                   only_integer: true }
 validate :not_yet_future
 
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def not_yet_future
    if self.year.present? && self.year > Time.now.year
       errors.add(:year, "is in the future!")
    end
  end


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
