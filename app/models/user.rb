class User < ActiveRecord::Base
  include RatingAverage



  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }

  has_secure_password
  validates :password, format: {
      with: /(?=.*[A-Z])(?=.*[0-9]).{4,}/, message: "must contain at least one uppercase and one digit" }
  validates :password, length: { minimum: 4 }


  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships


  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end


  def favorite(category)
    return nil if ratings.empty?

    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(category, item) }.first
  end


  private

  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end


  def self.most_ratings(n)
    sorted_by_ratings_count_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count||0) }.slice(0,n)
  end


end
