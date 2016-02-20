class Style < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :name, presence: true

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

end
