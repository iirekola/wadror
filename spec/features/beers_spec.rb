require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Testi" }

  it "is created when name isn't empty" do
    visit new_beer_path
    fill_in('beer[name]', with:'Testin paras')
    select('Lager', from:'beer[style]')
    select('Testi', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
    expect(brewery.beers.count).to eq(1)
  end

  it "is not saved if name is empty" do
    visit new_beer_path
    fill_in('beer[name]', with:' ')
    select('Lager', from:'beer[style]')
    select('Testi', from:'beer[brewery_id]')
    click_button "Create Beer"

    expect{
      click_button "Create Beer"
    }.not_to change{Beer.count}

    expect(page).to have_content 'Name can\'t be blank'
  end
end