require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", js: true do
    visit beerlist_path
    save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it "lists beers alphabetically by default", js: true do
    visit beerlist_path
    save_and_open_page

    first = page.all('tr')[1].text
    sec = page.all('tr')[2].text
    third = page.all('tr')[3].text

    expect(first).to have_content "Fastenbier"
    expect(sec).to have_content "Lechte Weisse"
    expect(first).to have_content "Nikolai"
  end

  it "lists beers by style", js: true do
    visit beerlist_path
    click_link "Style"
    save_and_open_page

    first = page.all('tr')[1].text
    sec = page.all('tr')[2].text
    third = page.all('tr')[3].text

    expect(first).to have_content "Lager"
    expect(sec).to have_content "Rauchbier"
    expect(first).to have_content "Weizen"
  end

  it "lists beers by brewery", js: true do
    visit beerlist_path
    click_link "Brewery"
    save_and_open_page

    first = page.all('tr')[1].text
    sec = page.all('tr')[2].text
    third = page.all('tr')[3].text

    expect(first).to have_content "Ayinger"
    expect(sec).to have_content "Koff"
    expect(first).to have_content "Schlenkerla"
  end
end