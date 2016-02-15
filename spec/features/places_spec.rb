require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
    [ Place.new(name: "Oljenkorsi", id: 1)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, all of them are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
    [ Place.new(name: "Oljenkorsi", id: 1), Place.new(name:"Olutbaari", id: 2), Place.new(name:"Pubi", id: 3)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "search"

    expect(page).to have_content "Oljenkorsi" and "Olutbaari" and "Pubi"
  end

  it "if none is returned by the API, notice is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "search"

    expect(page).to have_content "No locations in kumpula"
  end
end
