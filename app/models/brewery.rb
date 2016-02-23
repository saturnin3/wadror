class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   only_integer: true }

  validate :not_yet_future

  scope :active, -> {where active:true}
  scope :retired, -> {where active:[nil,false]}

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

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }.slice(0,n)
  end


end
