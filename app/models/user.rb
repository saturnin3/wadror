class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }

  validates :password, format: { with: /\A(([a-zA-Z0-9]*\d+[a-zA-Z0-9]*[A-Z]+[a-zA-Z0-9]*)|([a-zA-Z0-9]*[A-Z]+[a-zA-Z0-9]*\d+[a-zA-Z0-9]*))*\z/,
                                                          message: "must contain at least one uppercase and one digit" }
  validates :password, length: { minimum: 4 }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

end
