require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with name and style" do
    style1 = FactoryGirl.create(:style)
    beer = Beer.create name:"Karhu", style: style1

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  it "is not saved without name" do
    beer = Beer.create style_id: 1

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  it "is not saved without style id" do
    beer = Beer.create name:"Karhu"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

end
