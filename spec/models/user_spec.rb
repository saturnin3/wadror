require 'rails_helper'

include Helpers

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
    let (:brewery){FactoryGirl.create(:brewery)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, "Lager", brewery, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      #beer1 = FactoryGirl.create(:beer)
      #beer2 = FactoryGirl.create(:beer)
      #beer3 = FactoryGirl.create(:beer)
      #rating1 = FactoryGirl.create(:rating, beer:beer1, user:user)
      #rating2 = FactoryGirl.create(:rating, score:25, beer:beer2, user:user)
      #rating3 = FactoryGirl.create(:rating, score:9, beer:beer3, user:user)
      create_beers_with_ratings(user, "Lager", brewery, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, "IPA", brewery, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let (:user){FactoryGirl.create(:user)}
    let (:brewery){FactoryGirl.create(:brewery)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only beer rated if only one rating" do
      beer = create_beer_with_rating(user, "Lager", brewery, 10)

      expect(user.favorite_style).to eq("Lager")
    end

    it "is the style with highest average score if several rated" do
      create_beers_with_ratings(user, "Lager", brewery, 10, 30)
      create_beers_with_ratings(user, "IPA", brewery, 35, 15, 17)

      expect(user.favorite_style).to eq("IPA")
    end

  end #end describing favorite style

  describe "favorite brewery" do
    let (:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only beer rated if only one rating" do
      brewery = FactoryGirl.create(:brewery)
      beer = FactoryGirl.create(:beer, brewery: brewery)
      FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with highest average score if several rated" do
      brewery1 = FactoryGirl.create(:brewery)
      brewery2 = FactoryGirl.create(:brewery)
      brewery3 = FactoryGirl.create(:brewery)
      create_beers_with_ratings(user, "Lager", brewery1, 10, 20, 15, 7, 9 )
      create_beers_with_ratings(user, "IPA", brewery2, 25, 20)
      create_beers_with_ratings(user, "Stout", brewery3, 20, 23, 22)

      expect(user.favorite_brewery).to eq(brewery2)
    end

  end #end describing favorite brewery

end
