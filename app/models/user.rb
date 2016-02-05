class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }

  validates :password, format: { with: /(?=.*[A-Z])(?=.*[0-9]).{4,}/, message: "must contain at least one uppercase and one digit" }
  validates :password, length: { minimum: 4 }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

end
