class BeerClub < ActiveRecord::Base
  has_many :users, through: :memberships

  def index
    @beer_clubs = BeerClub.all
  end

  def to_s
    "#{self.name} #{self.city}"
  end

end
