require 'rails_helper'

RSpec.describe "Routing", type: :routing do
  it "should always redirect root(/) to channels#show" do
    FactoryBot.create(:channel)
    FactoryBot.create(:channel, name: 'general')

    expect(get("/")).to route_to("channels#show")
  end
end
