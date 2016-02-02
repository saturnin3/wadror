class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  #validates :user_id, uniqueness: { scope: :beer_club_id, message: "Membership exists already." }
  #validates :beer_club_id, uniqueness: { scope: :user_id, message: "Membership exists already."}
  #validates :user_id, presence: true

end
