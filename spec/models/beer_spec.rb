require 'rails_helper'



RSpec.describe Beer, type: :model do

  it "is not saved without a name" do
    beer = Beer.create

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Testin paras"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is saved with a name and a style" do
    beer = Beer.create name:"Testin paras", style:"Lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

end
