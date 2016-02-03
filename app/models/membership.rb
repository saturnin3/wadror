class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates :user_id, uniqueness: { scope: :beer_club_id }
  #validate :not_yet_member

#  def not_yet_member
#    b = Membership.where user_id:user_id
#    if not b.find_by(beer_club_id:beer_club_id).nil?
#      errors.add(:user_id, "already a member")
#    end
#  end     

end
