require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username:"Pekka", password:"Ab1", password_confirmation:"Ab1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with invalid password" do
    user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){FactoryGirl.create(:user)}

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end


    it "and with two ratings, has the correct average rating" do
      #user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let (:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user,10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      #beer1 = FactoryGirl.create(:beer)
      #beer2 = FactoryGirl.create(:beer)
      #beer3 = FactoryGirl.create(:beer)
      #rating1 = FactoryGirl.create(:rating, beer:beer1, user:user)
      #rating2 = FactoryGirl.create(:rating, score:25, beer:beer2, user:user)
      #rating3 = FactoryGirl.create(:rating, score:9, beer:beer3, user:user)
      create_beers_with_ratings(user,10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let (:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only beer rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_style).to eq(beer.style)
    end

    #it "is the one with highest average rating if several rated" do
    #  create_beers_with_style_and_ratings(user, "Lager", 10, 30)
    #  create_beers_with_style_and_ratings(user, "IPA", 15, 17)
    #  best = create_beer_with_style_and_rating(user, "IPA", 35)

    #  expect(user.favorite_style).to eq(best.style)
    #end

  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating(user, score)
  end
end

def create_beer_with_style_and_rating(user, style, score)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_style_and_ratings(user, style, *scores)
  scores.each do |score|
    create_beer_with_style_and_rating(user, style, score)
  end
end
