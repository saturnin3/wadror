class Rating < ActiveRecord::Base
  belongs_to :beer
  
  def to_s
    b = self.beer_id
    bisse = Beer.find b
    "#{bisse.name} #{score}"
  end

end
