require 'rails_helper'

describe "creating new beer" do
  let!(:brewery) {FactoryGirl.create :brewery, name:"Koff"}

  it "when created with valid name, is added to the system" do
    visit new_beer_path

    fill_in('beer_name', with: 'Olut')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect {
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "is redirected to new beer form, if no beer name given" do
    visit new_beer_path

    #fill_in('beer_name', with: '')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')
    click_button('Create Beer')
    puts page.html

    expect(Beer.count).to eq(0)
    expect(current_path).to eq(beers_path)
    expect(page).to have_content("Name can't be blank")

  end
end
