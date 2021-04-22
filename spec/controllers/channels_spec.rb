require 'rails_helper'
require_relative "../support/devise_helper"

RSpec.describe ChannelsController, type: :controller do
  context "#show" do
    it "with no channel should redirect to channels/general" do
      FactoryBot.create(:channel)
      FactoryBot.create(:channel, name: "general")

      sign_in!
      get :show

      expect(response).to redirect_to("/channels/general")
    end
  end
end
