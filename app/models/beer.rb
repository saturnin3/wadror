class Beer < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user


  def to_s
    i = self.brewery_id
    p = Brewery.find i
    "#{self.name} #{p.name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }.slice(0,n)
  end


end
