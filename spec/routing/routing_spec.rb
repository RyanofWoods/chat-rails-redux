require 'rails_helper'

RSpec.describe "Routing", type: :routing do
  it "should always redirect root(/) to channels#show" do
    expect(get("/")).to route_to("channels#show")
  end

  it "'/channels/test' should go to channels#show and id be 'test'" do
    expect(get("/channels/test")).to route_to("channels#show", id: "test")
  end
end
