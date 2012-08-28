require "minitest_helper"

# To be handled correctly this spec must end with "Acceptance Test"
describe LandingPagesController do

  before do
    @campaign = FactoryGirl.create(:campaign)
  end

  it "#show" do
    get "/see/#{@campaign.slug}"
  end

end
