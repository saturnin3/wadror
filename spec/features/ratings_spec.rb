require 'rails_helper'

include Helpers

describe "Ratings" do
  let!(:brewery) {FactoryGirl.create :brewery, name:"Koff"}
  let!(:style) {FactoryGirl.create :style, name:"Lager"}
  let!(:beer1) {FactoryGirl.create :beer, name:"iso 3", style:style, brewery:brewery}
  let!(:beer2) {FactoryGirl.create :beer, name:"Karhu", style:style, brewery:brewery}
  let!(:user) {FactoryGirl.create :user}

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is removed from the system when destroyed" do
    FactoryGirl.create(:rating, score: 10, beer:beer1, user:user)
    FactoryGirl.create(:rating, score: 15, beer:beer2, user:user)
    visit user_path(user)

    expect{
      find("a[href='/ratings/1']").click
      #click_link('delete')
    }.to change{user.ratings.count}.from(2).to(1)
  end

  describe "ratings page" do
    it "lists the existing ratings and their total number" do
      create_beers_with_ratings(user, style, brewery, 10, 20, 15, 7, 9)

      visit ratings_path

      expect(page).to have_content "Number of ratings #{Rating.count}"

      Rating.all.each do |rating|
        expect(page).to have_content "#{rating}"
      end
    end
  end

end
