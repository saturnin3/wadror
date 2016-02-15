require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end
end

describe "User's page" do
  let!(:brewery1) {FactoryGirl.create :brewery, name:"Koff"}
  let!(:brewery2){FactoryGirl.create :brewery, name:"Brewdog"}
  let!(:beer1) {FactoryGirl.create :beer, name:"iso 3", style:"Lager", brewery:brewery1}
  let!(:beer2) {FactoryGirl.create :beer, name:"Karhu", style:"Lager", brewery:brewery1}
  let!(:beer3){FactoryGirl.create :beer, name:"Punk IPA", style:"IPA", brewery:brewery2}
  let!(:user1) {FactoryGirl.create :user}
  let!(:user2) {FactoryGirl.create :user, username:"Brian", password: "Secret1", password_confirmation: "Secret1"}

  it "lists only user's ratings and shows favorite beer style and brewery" do
    #sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create(:rating, score:10, beer:beer1, user:user1)
    FactoryGirl.create(:rating, score:30, beer:beer3, user:user1)
    FactoryGirl.create(:rating, score:15, beer:beer2, user:user2)

    visit user_path(user1)

    expect(page).to have_content "Favorite beer style: IPA"
    expect(page).to have_content "Favorite brewery: Brewdog"
    expect(page).to have_content "iso 3 10"
    expect(page).not_to have_content "Karhu 15"
  end
end
