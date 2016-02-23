class Style < ActiveRecord::Base
  include RatingAverage
  
  validates :name, uniqueness: true
  validates :name, presence: true

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |b| -(b.average_rating||0) }.slice(0,n)
  end

end
