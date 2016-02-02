class Beer < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

#  def average_rating
#    total = 0
 #   self.ratings.each do |r|
  #   total += r.score
   # end
   # return total / self.ratings.count
  #  self.ratings.average(:score)
 #   total = self.ratings.inject(0){ |sum, n| sum + n.score }
   # total = self.ratings.map{ |r| r.score}.inject{ |sum, n| sum + n}
#    return total / self.ratings.count
#  end 
  def to_s
    i = self.brewery_id
    p = Brewery.find i
    "#{self.name} #{p.name}"
  end

end
